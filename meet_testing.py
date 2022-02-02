import subprocess


def main():
    configs = [
         "android-runner/config/config_meet_1.json",
         "android-runner/config/config_meet_2.json",
         "android-runner/config/config_meet_3.json",
         "android-runner/config/config_meet_4.json",
         "android-runner/config/config_meet_5.json",
         "android-runner/config/config_meet_6.json",        
    ]

    for config in configs:
        args = ["python3", "android-runner"]
        args.append(config)
        proc = subprocess.Popen(args)
        proc.wait()


if __name__ == '__main__':
    main()
