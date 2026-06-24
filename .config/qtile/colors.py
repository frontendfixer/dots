"""Re-export palette from the central user-color-palette source."""

import importlib.util
import os

_dir = os.path.dirname(os.path.abspath(__file__))
_candidates = [
    os.path.normpath(os.path.join(_dir, "..", "user-color-palette", "colors.py")),
    os.path.expanduser("~/.config/user-color-palette/colors.py"),
]

_palette_path = next((p for p in _candidates if os.path.isfile(p)), None)
if _palette_path is None:
    raise FileNotFoundError(
        "user-color-palette/colors.py not found; expected "
        + " or ".join(_candidates)
    )

_spec = importlib.util.spec_from_file_location("user_palette", _palette_path)
_palette = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_palette)

colors = _palette.colors
backgroundColor = _palette.backgroundColor
foregroundColor = _palette.foregroundColor
workspaceColor = _palette.workspaceColor
foregroundColorTwo = _palette.foregroundColorTwo
