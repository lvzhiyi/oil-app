"""Regression tests for check execution status; no SDK or source mutations."""
import contextlib
import importlib.util
import io
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('project_check', Path(__file__).with_name('check.py'))
check = importlib.util.module_from_spec(spec)
spec.loader.exec_module(check)


class ExecutionStatusTests(unittest.TestCase):
    def invoke(self, result=None, error=None, executable='/fake/tool'):
        output = io.StringIO()
        with patch.object(check.shutil, 'which', return_value=executable), patch.object(
            check.subprocess, 'run', return_value=result, side_effect=error
        ) as runner, contextlib.redirect_stdout(output), contextlib.redirect_stderr(output):
            code = check.run('probe', ['tool', 'argument'])
        return code, output.getvalue(), runner

    def test_success(self):
        code, output, runner = self.invoke(subprocess.CompletedProcess([], 0))
        self.assertEqual(code, 0)
        self.assertIn('status=PASS', output)
        runner.assert_called_once_with(['tool', 'argument'], cwd=check.ROOT, check=False)

    def test_failure_is_not_mislabeled_as_regression(self):
        code, output, _ = self.invoke(subprocess.CompletedProcess([], 7))
        self.assertNotEqual(code, 0)
        self.assertIn('status=CHECK_FAILED exit=7', output)
        self.assertIn('Cause: unclassified', output)

    def test_missing_tool_is_blocked_without_launch(self):
        code, output, runner = self.invoke(executable=None)
        self.assertEqual(code, 2)
        self.assertIn('status=BLOCKED reason=missing-tool', output)
        runner.assert_not_called()

    def test_permission_error_is_blocked_without_traceback(self):
        code, output, _ = self.invoke(error=PermissionError('denied'))
        self.assertEqual(code, 2)
        self.assertIn('status=BLOCKED reason=launch-error', output)


class EntryPointTests(unittest.TestCase):
    def test_failed_docs_returns_nonzero(self):
        with patch.object(check.sys, 'argv', ['check.py', 'docs']), patch.object(
            check, 'check_docs', return_value=1
        ), patch.object(check, 'run', return_value=0), contextlib.redirect_stdout(io.StringIO()):
            self.assertNotEqual(check.main(), 0)

    def test_source_inventory_failure_is_reported_as_blocked(self):
        output = io.StringIO()
        with patch.object(check.sys, 'argv', ['check.py', 'full']), patch.object(
            check, 'check_docs', return_value=0
        ), patch.object(check, 'run', return_value=0), patch.object(
            check.subprocess, 'check_output', side_effect=subprocess.CalledProcessError(1, 'git')
        ), contextlib.redirect_stdout(output):
            self.assertNotEqual(check.main(), 0)
        self.assertIn('[sources] status=BLOCKED', output.getvalue())


if __name__ == '__main__':
    unittest.main()
