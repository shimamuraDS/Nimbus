#!/usr/bin/env python3
"""Build Nimbus MSI + ZIP release assets from deploy directories.

Input:
  deploy/{variant}/   — complete deploy dirs (exe + windeployqt output)

Output (in scripts/):
  Nimbus_{variant}.msi
  Nimbus-v1.0.1-{variant}.zip

Requires: WiX Toolset v7 with WixToolset.UI.wixext installed.
"""

import subprocess, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEPLOY = ROOT / "deploy"
SCRIPTS_DEPLOY = ROOT / "scripts" / "deploy"
SCRIPTS = ROOT / "scripts"

VARIANTS = {
    "AI": {
        "name": "Nimbus AI",
        "dir": "ai",
        "upgrade_code": "9404FEBE-278C-41A8-ACFE-6704207F31AF",
    },
    "Standard": {
        "name": "Nimbus Standard",
        "dir": "standard",
        "upgrade_code": "0CF5BEF0-3574-4A1B-8118-D31CF6CC4489",
    },
}

VERSION = "v1.0.1"

def run(cmd, **kwargs):
    print(f"  $ {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=ROOT, **kwargs)
    if result.returncode != 0:
        print(f"  ERROR: exit code {result.returncode}")
        sys.exit(result.returncode)
    return result

def sync_deploy(variant_key):
    """Copy deploy/{dir}/* → scripts/deploy/{Variant}/"""
    cfg = VARIANTS[variant_key]
    src = DEPLOY / cfg["dir"]
    dst = SCRIPTS_DEPLOY / variant_key
    print(f"Syncing deploy files: {src} → {dst}")
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)
    # Remove files we don't want in the MSI
    for pat in ("*.wxs", "*.wixpdb"):
        for f in dst.rglob(pat):
            f.unlink()

def build_msi(variant_key):
    """Generate WXS and build MSI."""
    cfg = VARIANTS[variant_key]
    deploy_dir = SCRIPTS_DEPLOY / variant_key
    wxs_path = SCRIPTS / f"Nimbus_{variant_key}.wxs"
    msi_path = SCRIPTS / f"Nimbus_{variant_key}.msi"

    print(f"\n--- Building {cfg['name']} MSI ---")
    print("Generating WXS...")
    run([
        sys.executable,
        str(SCRIPTS / "generate_wxs.py"),
        str(deploy_dir),
        str(wxs_path),
        "--name", cfg["name"],
        "--upgrade-code", cfg["upgrade_code"],
    ])

    print("Building MSI...")
    run([
        "wix", "build",
        "-ext", "WixToolset.UI.wixext",
        "-o", str(msi_path),
        str(wxs_path),
    ])
    size_mb = msi_path.stat().st_size / (1024 * 1024)
    print(f"  {msi_path.name} — {size_mb:.1f} MB")

def build_zip(variant_key):
    """Create portable ZIP from deploy/{dir}/."""
    cfg = VARIANTS[variant_key]
    src = DEPLOY / cfg["dir"]
    zip_path = SCRIPTS / f"Nimbus-{VERSION}-{variant_key}.zip"

    print(f"\nCreating ZIP for {cfg['name']}...")
    # Remove old archives
    for old in SCRIPTS.glob(f"Nimbus-*-{variant_key}.zip"):
        old.unlink()
    shutil.make_archive(str(zip_path.with_suffix("")), "zip", src)
    size_mb = zip_path.stat().st_size / (1024 * 1024)
    print(f"  {zip_path.name} — {size_mb:.1f} MB")

def main():
    for key in ("AI", "Standard"):
        sync_deploy(key)
        build_msi(key)
        build_zip(key)
    print("\nDone. Assets in scripts/")

if __name__ == "__main__":
    main()
