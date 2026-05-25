import json
from pathlib import Path

notebook_path = Path(r"notebooks/Avance 3. Baseline/Avance3_23Equipo.ipynb")

with notebook_path.open("r", encoding="utf-8") as f:
    nb = json.load(f)

nb.get("metadata", {}).pop("widgets", None)

with notebook_path.open("w", encoding="utf-8") as f:
    json.dump(nb, f, ensure_ascii=False, indent=1)

print(f"Notebook corregido: {notebook_path}")