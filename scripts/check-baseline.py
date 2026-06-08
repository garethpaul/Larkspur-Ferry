#!/usr/bin/env python3
from pathlib import Path
import json
import plistlib
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / "docs/plans/2026-06-08-larkspur-ferry-baseline.md"
PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


def require(condition, message, failures):
    if not condition:
        failures.append(message)


def read(relative_path):
    return (ROOT / relative_path).read_text(encoding="utf-8", errors="replace")


def strip_swift_line_comments(text):
    return "\n".join(line.split("//", 1)[0] for line in text.splitlines())


def parse_xml(relative_path, failures):
    try:
        ET.parse(str(ROOT / relative_path))
    except ET.ParseError as error:
        failures.append(f"{relative_path} is not well-formed XML: {error}")


def parse_json(relative_path, failures):
    try:
        return json.loads(read(relative_path))
    except json.JSONDecodeError as error:
        failures.append(f"{relative_path} is not valid JSON: {error}")
        return {}


def parse_plist(relative_path, failures):
    try:
        with (ROOT / relative_path).open("rb") as file:
            return plistlib.load(file)
    except Exception as error:
        failures.append(f"{relative_path} is not a readable plist: {error}")
        return {}


def check_png(relative_path, failures):
    path = ROOT / relative_path
    try:
        with path.open("rb") as file:
            signature = file.read(len(PNG_SIGNATURE))
        require(signature == PNG_SIGNATURE, f"{relative_path} must be a PNG image", failures)
        require(path.stat().st_size > 100, f"{relative_path} must not be empty", failures)
    except OSError as error:
        failures.append(f"{relative_path} could not be read: {error}")


def git_ls_files():
    result = subprocess.run(["git", "ls-files"], cwd=str(ROOT), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        return set()
    return set(result.stdout.splitlines())


def main():
    failures = []
    required_files = [
        ".gitignore",
        ".travis.yml",
        "CHANGES.md",
        "Makefile",
        "Podfile",
        "Podfile.lock",
        "README.md",
        "SECURITY.md",
        "VISION.md",
        "build.sh",
        "docs/plans/2026-06-08-larkspur-ferry-baseline.md",
        "docs/plans/2026-06-08-map-refresh-timer-lifecycle.md",
        "docs/readme-overview.svg",
        "Screenshots/screenshot01.png",
        "Larkspur Ferry.xcworkspace/contents.xcworkspacedata",
        "Larkspur Ferry.xcodeproj/project.pbxproj",
        "Larkspur Ferry.xcodeproj/project.xcworkspace/contents.xcworkspacedata",
        "Larkspur Ferry.xcodeproj/xcshareddata/xcschemes/Larkspur Ferry.xcscheme",
        "Larkspur Ferry.xcodeproj/xcshareddata/xcschemes/Larkspur FerryUITests.xcscheme",
        "Larkspur Ferry/Info.plist",
        "Larkspur Ferry/API.swift",
        "Larkspur Ferry/Extensions.swift",
        "Larkspur Ferry/ViewController.swift",
        "Larkspur Ferry/MapViewController.swift",
        "Larkspur Ferry/PinAnnotation.swift",
        "Larkspur Ferry/Base.lproj/Main.storyboard",
        "Larkspur Ferry/Base.lproj/LaunchScreen.storyboard",
        "Larkspur Ferry/Assets.xcassets/AppIcon.appiconset/Contents.json",
        "Larkspur Ferry/Assets.xcassets/boatLogo.imageset/boatLogo.png",
        "Larkspur FerryUITests/Info.plist",
        "Larkspur FerryUITests/Larkspur_FerryUITests.swift",
        "Larkspur FerryUITests/SnapshotHelper.swift",
    ]

    for relative_path in required_files:
        require((ROOT / relative_path).is_file(), f"Required file missing: {relative_path}", failures)

    for xml_file in [
        "docs/readme-overview.svg",
        "Larkspur Ferry.xcworkspace/contents.xcworkspacedata",
        "Larkspur Ferry.xcodeproj/project.xcworkspace/contents.xcworkspacedata",
        "Larkspur Ferry.xcodeproj/xcshareddata/xcschemes/Larkspur Ferry.xcscheme",
        "Larkspur Ferry.xcodeproj/xcshareddata/xcschemes/Larkspur FerryUITests.xcscheme",
        "Larkspur Ferry/Base.lproj/Main.storyboard",
        "Larkspur Ferry/Base.lproj/LaunchScreen.storyboard",
    ]:
        parse_xml(xml_file, failures)

    for json_file in [
        "Larkspur Ferry/Assets.xcassets/AppIcon.appiconset/Contents.json",
        "Larkspur Ferry/Assets.xcassets/boatLogo.imageset/Contents.json",
        "Larkspur Ferry/Assets.xcassets/marin.imageset/Contents.json",
        "Larkspur Ferry/Assets.xcassets/sanfrancisco.imageset/Contents.json",
    ]:
        parse_json(json_file, failures)

    for image_file in [
        "Screenshots/screenshot01.png",
        "Larkspur Ferry/Assets.xcassets/boatLogo.imageset/boatLogo.png",
        "Larkspur Ferry/Assets.xcassets/marin.imageset/marin.png",
        "Larkspur Ferry/Assets.xcassets/sanfrancisco.imageset/sanfrancisco.png",
    ]:
        check_png(image_file, failures)

    app_plist = parse_plist("Larkspur Ferry/Info.plist", failures)
    test_plist = parse_plist("Larkspur FerryUITests/Info.plist", failures)
    project = read("Larkspur Ferry.xcodeproj/project.pbxproj")
    build_script = read("build.sh")
    api = read("Larkspur Ferry/API.swift")
    extensions = read("Larkspur Ferry/Extensions.swift")
    view_controller = read("Larkspur Ferry/ViewController.swift")
    map_controller = read("Larkspur Ferry/MapViewController.swift")
    pin_annotation = read("Larkspur Ferry/PinAnnotation.swift")
    app_swift = "\n".join(strip_swift_line_comments(path.read_text(encoding="utf-8", errors="replace"))
                          for path in sorted((ROOT / "Larkspur Ferry").glob("*.swift")))
    readme = read("README.md")
    vision = read("VISION.md")
    security = read("SECURITY.md")
    changes = read("CHANGES.md")
    makefile = read("Makefile")
    overview = read("docs/readme-overview.svg")
    gitignore = read(".gitignore")
    podfile = read("Podfile")
    podlock = read("Podfile.lock")
    plan = PLAN.read_text(encoding="utf-8") if PLAN.exists() else ""
    timer_plan = read("docs/plans/2026-06-08-map-refresh-timer-lifecycle.md")

    shell_result = subprocess.run(["sh", "-n", "build.sh"], cwd=str(ROOT), text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    require(shell_result.returncode == 0,
            f"build.sh must pass POSIX shell syntax checks: {shell_result.stderr.strip()}",
            failures)
    require("function ci_build" not in build_script and "ci_build() {" in build_script and "ci_test() {" in build_script,
            "build.sh must use POSIX-compatible shell function syntax",
            failures)
    require("command -v pod" in build_script and "command -v xcodebuild" in build_script and "skipping Xcode build" in build_script,
            "build.sh must skip cleanly when CocoaPods or Xcode are unavailable",
            failures)
    require("./build.sh" in makefile,
            "make check must invoke the guarded build script",
            failures)

    require(app_plist.get("NSLocationWhenInUseUsageDescription"),
            "app Info.plist must document when-in-use location permission",
            failures)
    require(test_plist.get("CFBundlePackageType") == "BNDL",
            "UI test Info.plist must remain a bundle plist",
            failures)
    require("INFOPLIST_FILE = \"Larkspur Ferry/Info.plist\";" in project and "SWIFT_VERSION = 3.0;" in project,
            "Xcode project must preserve app plist wiring and Swift version",
            failures)
    require("CoreLocation.framework" in project and "Pods_Larkspur_Ferry.framework" in project,
            "Xcode project must keep CoreLocation and CocoaPods framework references",
            failures)
    require("Alamofire', '~> 4.0'" in podfile and "Alamofire (4.3.0)" in podlock,
            "Podfile and lockfile must preserve the pinned Alamofire baseline",
            failures)

    require('private let apiBaseURL = "https://requestlabs.appspot.com/"' in api,
            "API base URL must remain HTTPS and visible",
            failures)
    require("completion(nil)" in api and "guard let result = JSON as? JSONObject" in api,
            "API location parsing must handle malformed payloads without force unwraps",
            failures)
    require("guard let arrive" in api and "completion(boats)" in api,
            "API schedule parsing must skip malformed ferry rows and always complete",
            failures)
    require("parameters?.stringFromHttpParameters() ?? \"\"" in api and "guard let url = URL" in api,
            "API request builder must avoid force-unwrapping parameters and URLs",
            failures)
    require("print(" not in strip_swift_line_comments(api),
            "API source must not print network failures",
            failures)
    require("guard let keyString" in extensions and "String(describing: value)" in extensions,
            "HTTP parameter encoding must avoid force-casts and force-unwrapped escapes",
            failures)
    require("guard indexPath.row < self.items.count" in view_controller and "date.map" in view_controller,
            "table rendering must guard indexes, cell casts, and invalid ferry times",
            failures)
    require("locations.last" in view_controller and "placemarks?.first" in view_controller and "status == .denied" in view_controller,
            "location handling must guard missing locations, geocoder data, and denied authorization",
            failures)
    require("print(" not in strip_swift_line_comments(view_controller),
            "app location flow must not print debug output",
            failures)
    require("guard let location = location" in map_controller and "as? CustomPointAnnotation" in map_controller,
            "map flow must guard missing API location and annotation casts",
            failures)
    require("var locationRefreshTimer: Timer?" in map_controller and "func startLocationRefreshTimer()" in map_controller,
            "map flow must keep the ferry-location refresh timer visible and restartable",
            failures)
    require("viewWillAppear" in map_controller and "startLocationRefreshTimer()" in map_controller,
            "map flow must start the refresh timer when the map appears",
            failures)
    require("viewWillDisappear" in map_controller and "locationRefreshTimer?.invalidate()" in map_controller and "locationRefreshTimer = nil" in map_controller,
            "map flow must invalidate the refresh timer when the map disappears",
            failures)
    require("let timer = Timer.scheduledTimer" not in map_controller,
            "map flow must not hide the scheduled timer in a local variable",
            failures)
    require('var imageName = ""' in pin_annotation,
            "custom annotation image name must not be implicitly unwrapped",
            failures)
    for forbidden in ["as!", "try!", "manager.location!", "date!", "parameters!", "toDouble()!", "print("]:
        require(forbidden not in app_swift,
                f"first-party app Swift must avoid unsafe or debug pattern: {forbidden}",
                failures)

    tracked = git_ls_files()
    require("Larkspur Ferry/Assets.xcassets/.DS_Store" not in tracked,
            "asset catalog .DS_Store must not be tracked",
            failures)
    require(".DS_Store" in gitignore and "Pods/" in gitignore and "DerivedData" in gitignore,
            ".gitignore must exclude generated Xcode, CocoaPods, and Finder metadata",
            failures)
    require("make check" in readme and "scripts/check-baseline.py" in readme and "location" in readme.lower(),
            "README must document static verification and location/API guardrails",
            failures)
    require("Larkspur Ferry.xcworkspace" in readme,
            "README must direct CocoaPods users to the workspace",
            failures)
    require("map refresh timer" in readme and "map refresh timer" in vision and "map refresh timer" in security,
            "docs must describe map refresh timer lifecycle handling",
            failures)
    require("Alamofire" in overview and "MapKit" in overview and "Integrations: Twitter" not in overview,
            "overview SVG must name the real app integrations",
            failures)
    require("scripts/check-baseline.py" in vision and "API" in vision and "location" in vision.lower(),
            "VISION must describe the current Larkspur Ferry baseline",
            failures)
    require("make check" in security and "location" in security.lower() and "API" in security,
            "SECURITY must document location/API static guardrails",
            failures)
    require("build.sh" in changes and "force-unwrapping" in changes and ".DS_Store" in changes and "map refresh timer" in changes,
            "CHANGES must record build, force unwrap, generated metadata, and timer lifecycle hardening",
            failures)
    require("status: completed" in plan,
            "plan must be marked completed",
            failures)
    require("status: completed" in timer_plan,
            "map refresh timer lifecycle plan must be marked completed",
            failures)

    if shutil.which("xcodebuild"):
        print("xcodebuild is available; run ./build.sh or Xcode UI tests on macOS before release.")
    else:
        print("xcodebuild unavailable; static iOS baseline only.")

    if failures:
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1

    print("Larkspur Ferry baseline checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
