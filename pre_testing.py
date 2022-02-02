import subprocess


def main():
    configs = [
        #"android-runner/config/preconfig_zoom_3.json",
        #"android-runner/config/preconfig_zoom_5.json",
        #"android-runner/config/preconfig_zoom_7.json",
        #"android-runner/config/preconfig_zoom_9.json",
        #"android-runner/config/preconfig_zoom_10.json",
        #"android-runner/config/preconfig_meet_3.json",
        #"android-runner/config/preconfig_meet_5.json",
        #"android-runner/config/preconfig_meet_7.json",
        #"android-runner/config/preconfig_meet_9.json",
        "android-runner/config/preconfig_meet_10.json",
    ]

    for config in configs:
        args = ["python3", "android-runner"]
        args.append(config)
        proc = subprocess.Popen(args)
        proc.wait()


if __name__ == '__main__':
    main()
