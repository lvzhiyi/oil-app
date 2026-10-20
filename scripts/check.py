#!/usr/bin/env python3
"""Non-mutating source checks. SDK/build tools may write their own caches."""
import argparse
from pathlib import Path
import re
import shutil
import subprocess
import sys
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[1]


def check_docs():
    paths = [ROOT / 'AGENTS.md', ROOT / 'openspec/project.md']
    paths += sorted((ROOT / 'docs/development').glob('*.md'))
    errors = []
    for path in paths:
        if not path.is_file():
            errors.append(f'Missing document: {path.relative_to(ROOT)}')
            continue
        content = path.read_text(encoding='utf-8')
        for target in re.findall(r'\[[^\]]*\]\(([^\s)]+)\)', content):
            if re.match(r'^[a-zA-Z][a-zA-Z0-9+.-]*:', target):
                continue
            name, _, anchor = unquote(target).partition('#')
            dest = (path.parent / name).resolve() if name else path
            if not dest.exists():
                errors.append(f'{path.relative_to(ROOT)}: broken link {target}')
            elif anchor and dest.suffix == '.md':
                headings = []
                for title in re.findall(r'^#{1,6}\s+(.+)$', dest.read_text(encoding='utf-8'), re.M):
                    title = re.sub(r'[^\w\- ]', '', title.lower()).replace(' ', '-')
                    count = headings.count(title)
                    headings.append(title)
                    if anchor == title or (count and anchor == f'{title}-{count}'):
                        break
                else:
                    errors.append(f'{path.relative_to(ROOT)}: missing heading {target}')
    for error in errors:
        print(error, file=sys.stderr)
    print(f'Document links: {len(paths)} files, {len(errors)} errors', flush=True)
    return int(bool(errors))


def run(label, command):
    print(f'\n[{label}] {" ".join(command)}', flush=True)
    if not shutil.which(command[0]):
        print(f'BLOCKED: missing executable {command[0]}', file=sys.stderr)
        print(f'[{label}] status=BLOCKED reason=missing-tool', flush=True)
        return 2
    try:
        result = subprocess.run(command, cwd=ROOT, check=False)
    except OSError as error:
        print(f'[{label}] status=BLOCKED reason=launch-error: {error}', flush=True)
        return 2
    state = 'PASS' if result.returncode == 0 else 'CHECK_FAILED'
    print(f'[{label}] status={state} exit={result.returncode}', flush=True)
    if result.returncode:
        print('Cause: unclassified; compare baseline and investigate before attributing.', flush=True)
    return int(result.returncode != 0)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=['docs', 'full'], nargs='?', default='full')
    args = parser.parse_args()
    failures = check_docs()
    failures += run('diff', ['git', 'diff', '--check'])
    if args.mode == 'full':
        # Use Git's inventory, plus untracked source files; never stage or stash.
        try:
            names = subprocess.check_output(
                ['git', 'ls-files', '-z', '--cached', '--others', '--exclude-standard'], cwd=ROOT
            ).decode().split('\0')
        except (OSError, subprocess.CalledProcessError) as error:
            print(f'[sources] status=BLOCKED: cannot list source files: {error}', flush=True)
            return 1
        suffixes = ('.g.dart', '.freezed.dart', '.gr.dart', '.mocks.dart', '.iconfig.dart',
                    '.injection.dart', '.router.dart', '.r.g.dart', '.part.dart')
        sources = sorted({name for name in names if name.endswith('.dart')
                          and name.startswith(('lib/', 'test/', 'scripts/'))
                          and not name.endswith(suffixes)
                          and (ROOT / name).is_file()})
        if not sources:
            print('BLOCKED: no Dart source files found', file=sys.stderr)
            failures += 1
        else:
            failures += run('format', ['dart', 'format', '--output=none',
                                      '--set-exit-if-changed', *sources])
        failures += run('analyze', ['flutter', 'analyze', '--no-pub'])
        failures += run('test', ['flutter', 'test', '--no-pub'])
    print(f'\nResult: {"FAIL" if failures else "PASS"}', flush=True)
    return int(bool(failures))


if __name__ == '__main__':
    sys.exit(main())
