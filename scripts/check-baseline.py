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
MAIN_THREAD_PLAN = ROOT / "docs/plans/2026-06-09-main-thread-ui-updates.md"
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
        ".github/workflows/check.yml",
        "AGENTS.md",
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
        "docs/plans/2026-06-08-location-update-single-shot.md",
        "docs/plans/2026-06-08-map-annotation-refresh.md",
        "docs/plans/2026-06-08-map-refresh-timer-lifecycle.md",
        "docs/plans/2026-06-09-deterministic-http-parameters.md",
        "docs/plans/2026-06-09-locale-independent-coordinate-parsing.md",
        "docs/plans/2026-06-09-make-gate-aliases.md",
        "docs/plans/2026-06-09-posix-schedule-time-parsing.md",
        "docs/plans/2026-06-09-main-thread-ui-updates.md",
        "docs/plans/2026-06-10-map-refresh-failure-preserves-pin.md",
        "docs/plans/2026-06-10-hosted-project-validation.md",
        "docs/plans/2026-06-10-validated-ferry-responses.md",
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
    agents = read("AGENTS.md")
    makefile = read("Makefile")
    overview = read("docs/readme-overview.svg")
    gitignore = read(".gitignore")
    podfile = read("Podfile")
    podlock = read("Podfile.lock")
    plan = PLAN.read_text(encoding="utf-8") if PLAN.exists() else ""
    timer_plan = read("docs/plans/2026-06-08-map-refresh-timer-lifecycle.md")
    location_plan = read("docs/plans/2026-06-08-location-update-single-shot.md")
    parameter_plan = read("docs/plans/2026-06-09-deterministic-http-parameters.md")
    coordinate_plan = read("docs/plans/2026-06-09-locale-independent-coordinate-parsing.md")
    make_gates_plan = read("docs/plans/2026-06-09-make-gate-aliases.md")
    schedule_time_plan = read("docs/plans/2026-06-09-posix-schedule-time-parsing.md")
    main_thread_plan = MAIN_THREAD_PLAN.read_text(encoding="utf-8") if MAIN_THREAD_PLAN.exists() else ""
    map_failure_plan = read("docs/plans/2026-06-10-map-refresh-failure-preserves-pin.md")
    hosted_validation_plan = read("docs/plans/2026-06-10-hosted-project-validation.md")
    validated_response_plan = read("docs/plans/2026-06-10-validated-ferry-responses.md")
    workflow = read(".github/workflows/check.yml")
    annotation_plan_path = ROOT / "docs/plans/2026-06-08-map-annotation-refresh.md"
    annotation_plan = annotation_plan_path.read_text(encoding="utf-8", errors="replace") if annotation_plan_path.exists() else ""

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
    require('SKIP_XCODE_BUILD:-' in build_script and 'SKIP_XCODE_BUILD=1' in build_script,
            "build.sh must support explicit hosted structural validation without a legacy build",
            failures)
    require(".PHONY: build check lint test" in makefile and "lint test build: check" in makefile and
            "./build.sh" in makefile,
            "Makefile must expose standard gates that invoke the guarded build script",
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
    require("private let requestTimeout: TimeInterval = 10" in api and
            "urlRequest.cachePolicy = .reloadIgnoringLocalCacheData" in api and
            "urlRequest.timeoutInterval = requestTimeout" in api,
            "API requests must use a bounded timeout and bypass stale cached ferry data",
            failures)
    require(".validate(statusCode: 200..<300)" in api and
            '.validate(contentType: ["application/json"])' in api and
            api.find(".validate(statusCode: 200..<300)") < api.find(".responseJSON"),
            "API responses must validate successful status and JSON content before parsing",
            failures)
    require("print(" not in strip_swift_line_comments(api),
            "API source must not print network failures",
            failures)
    require("guard let keyString" in extensions and "String(describing: value)" in extensions,
            "HTTP parameter encoding must avoid force-casts and force-unwrapped escapes",
            failures)
    require("return Double(self)" in extensions and "NumberFormatter().number(from:" not in extensions,
            "coordinate parsing must stay locale-independent for ferry API latitude and longitude strings",
            failures)
    require("}.sorted()" in extensions and 'joined(separator: "&")' in extensions,
            "HTTP parameter encoding must produce deterministic query parameter order",
            failures)
    require("guard indexPath.row < self.items.count" in view_controller and "date.map" in view_controller,
            "table rendering must guard indexes, cell casts, and invalid ferry times",
            failures)
    require("API.sharedInstance.getTimes(from: f) { [weak self]" in view_controller and
            "DispatchQueue.main.async" in view_controller and
            "guard let viewController = self else" in view_controller and
            "viewController.tableView.reloadData()" in view_controller,
            "schedule API callback must update table state on the main queue without retaining the view controller",
            failures)
    require('dateFormatter.locale = Locale(identifier: "en_US_POSIX")' in view_controller,
            "schedule time parsing must use a POSIX locale for fixed-format API times",
            failures)
    require("locations.last" in view_controller and "placemarks?.first" in view_controller and "status == .denied" in view_controller,
            "location handling must guard missing locations, geocoder data, and denied authorization",
            failures)
    require("func loadScheduleWithoutLocation()" in view_controller and "locationUpdated = false" in view_controller and "guard !locationUpdated else" in view_controller,
            "location handling must reset lookup state, ignore repeated updates, and use a shared schedule fallback",
            failures)
    require("locationManager.stopUpdatingLocation()" in view_controller and "didFailWithError" in view_controller and "loadScheduleWithoutLocation()" in view_controller,
            "location handling must stop updates on successful and unavailable location paths",
            failures)
    require("print(" not in strip_swift_line_comments(view_controller),
            "app location flow must not print debug output",
            failures)
    require("guard let location = location" in map_controller and "as? CustomPointAnnotation" in map_controller,
            "map flow must guard missing API location and annotation casts",
            failures)
    require("API.sharedInstance.getLocation(completion: { [weak self]" in map_controller and
            "DispatchQueue.main.async" in map_controller and
            "guard let viewController = self else" in map_controller and
            "viewController.mapView.addAnnotation(info1)" in map_controller,
            "map API callback must update MapKit state on the main queue without retaining the view controller",
            failures)
    require("func removeExistingFerryAnnotations()" in map_controller and
            "filter { $0 is CustomPointAnnotation }" in map_controller and
            "mapView.removeAnnotations(ferryAnnotations)" in map_controller,
            "map flow must remove existing ferry annotations without clearing unrelated annotations",
            failures)
    require(map_controller.count("removeExistingFerryAnnotations()") >= 2 and "if self.mapView.annotations.count == 1" not in map_controller,
            "map flow must refresh ferry annotations without relying on the total annotation count",
            failures)
    require("func getLocation() {\n        API.sharedInstance.getLocation" in map_controller and
            "viewController.removeExistingFerryAnnotations()" in map_controller,
            "map flow must preserve the last ferry annotation until a successful refresh replaces it",
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
    require("make lint" in readme and "make test" in readme and "make build" in readme and
            "make check" in readme and "scripts/check-baseline.py" in readme and "location" in readme.lower(),
            "README must document static verification gates and location/API guardrails",
            failures)
    require("Larkspur Ferry.xcworkspace" in readme,
            "README must direct CocoaPods users to the workspace",
            failures)
    require("map refresh timer" in readme and "map refresh timer" in vision and "map refresh timer" in security,
            "docs must describe map refresh timer lifecycle handling",
            failures)
    require("ferry annotation refresh" in readme.lower() and
            "ferry annotation refresh" in vision.lower() and
            "ferry annotation refresh" in security.lower(),
            "docs must describe ferry annotation refresh handling",
            failures)
    require("single-shot location" in readme and "single-shot location" in vision and "single-shot location" in security,
            "docs must describe single-shot location lookup handling",
            failures)
    require("deterministic query" in readme.lower() and
            "deterministic query" in vision.lower() and
            "deterministic query" in security.lower(),
            "docs must describe deterministic query parameter encoding",
            failures)
    require("locale-independent coordinate parsing" in readme.lower() and
            "locale-independent coordinate parsing" in vision.lower() and
            "locale-independent coordinate parsing" in security.lower(),
            "docs must describe locale-independent coordinate parsing",
            failures)
    require("posix schedule time parsing" in readme.lower() and
            "posix schedule time parsing" in vision.lower() and
            "posix schedule time parsing" in security.lower(),
            "docs must describe POSIX schedule time parsing",
            failures)
    require("main-thread ui updates" in readme.lower() and
            "main-thread ui updates" in vision.lower() and
            "main-thread ui updates" in security.lower(),
            "docs must describe main-thread UI update handling",
            failures)
    require("failed map-location refresh" in readme.lower() and
            "failed map-location refresh" in vision.lower() and
            "failed map-location refresh" in security.lower(),
            "docs must describe failed map-location refresh handling",
            failures)
    require("Alamofire" in overview and "MapKit" in overview and "Integrations: Twitter" not in overview,
            "overview SVG must name the real app integrations",
            failures)
    require("scripts/check-baseline.py" in vision and "make lint" in vision and "make test" in vision and
            "make build" in vision and "API" in vision and "location" in vision.lower(),
            "VISION must describe the current Larkspur Ferry baseline",
            failures)
    require("make check" in security and "location" in security.lower() and "API" in security,
            "SECURITY must document location/API static guardrails",
            failures)
    require("pod install" in agents and "Larkspur Ferry.xcworkspace" in agents and
            "make lint" in agents and "make test" in agents and "make build" in agents and
            "make check" in agents and "force-unwrapped API payloads" in agents and
            "location data" in agents,
            "AGENTS.md must preserve CocoaPods, verification, API, and location guardrails",
            failures)
    require("build.sh" in changes and "force-unwrapping" in changes and ".DS_Store" in changes and "map refresh timer" in changes and "single-shot location" in changes,
            "CHANGES must record build, force unwrap, generated metadata, timer lifecycle, and location lookup hardening",
            failures)
    require("ferry annotation refresh" in changes,
            "CHANGES must record ferry annotation refresh hardening",
            failures)
    require("deterministic query" in changes.lower(),
            "CHANGES must record deterministic query parameter encoding",
            failures)
    require("locale-independent coordinate parsing" in changes.lower(),
            "CHANGES must record locale-independent coordinate parsing",
            failures)
    require("posix schedule time parsing" in changes.lower(),
            "CHANGES must record POSIX schedule time parsing",
            failures)
    require("main-thread ui updates" in changes.lower(),
            "CHANGES must record main-thread UI update handling",
            failures)
    require("failed map-location refresh" in changes.lower(),
            "CHANGES must record failed map-location refresh handling",
            failures)
    require("make lint" in changes and "make test" in changes and "make build" in changes,
            "CHANGES must record the standard local gate aliases",
            failures)
    require("status: completed" in plan,
            "plan must be marked completed",
            failures)
    require("status: completed" in timer_plan,
            "map refresh timer lifecycle plan must be marked completed",
            failures)
    require("status: completed" in location_plan,
            "location update single-shot plan must be marked completed",
            failures)
    require("status: completed" in annotation_plan,
            "map annotation refresh plan must be marked completed",
            failures)
    require("status: completed" in parameter_plan,
            "deterministic HTTP parameter plan must be marked completed",
            failures)
    require("status: completed" in coordinate_plan,
            "locale-independent coordinate parsing plan must be marked completed",
            failures)
    require("status: completed" in make_gates_plan,
            "make gate aliases plan must be marked completed",
            failures)
    require("status: completed" in schedule_time_plan,
            "POSIX schedule time parsing plan must be marked completed",
            failures)
    require("status: completed" in main_thread_plan,
            "main-thread UI updates plan must be marked completed",
            failures)
    require("status: completed" in map_failure_plan,
            "map refresh failure plan must be marked completed",
            failures)
    require("status: completed" in hosted_validation_plan and "SKIP_XCODE_BUILD=1" in hosted_validation_plan,
            "hosted project validation plan must be marked completed",
            failures)
    require("status: completed" in validated_response_plan and "10-second" in validated_response_plan,
            "validated ferry response plan must be marked completed",
            failures)
    actions = re.findall(r"(?m)^\s*(?:-\s*)?uses:\s*(\S+)(?:\s+#.*)?$", workflow)
    checkout_step = re.search(
        r"(?m)^      - name: Check out repository\n"
        r"        uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10\n"
        r"        with:\n"
        r"          persist-credentials: false\n",
        workflow,
    )
    require(checkout_step is not None and
            actions == ["actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10"] and
            workflow.count("permissions:") == 1 and
            workflow.count("persist-credentials:") == 1 and
            re.search(r"(?m)^\s+[A-Za-z-]+:\s+write\s*$", workflow) is None and
            "permissions:\n  contents: read" in workflow and "cancel-in-progress: true" in workflow and
            "runs-on: macos-15" in workflow and "timeout-minutes: 10" in workflow and
            'SKIP_XCODE_BUILD: "1"' in workflow and
            "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" in workflow and
            "run: make check" in workflow,
            "Check workflow must use only pinned, credential-free checkout with singular read-only permissions and bounded structural validation",
            failures)

    if shutil.which("xcodebuild"):
        result = subprocess.run(
            ["xcodebuild", "-list", "-project", "Larkspur Ferry.xcodeproj"],
            cwd=ROOT,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            text=True,
        )
        require(result.returncode == 0,
                "xcodebuild could not parse Larkspur Ferry.xcodeproj: " + result.stderr.strip(), failures)
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
