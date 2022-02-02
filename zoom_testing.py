import subprocess


def main():
    configs = [
         #"android-runner/config/config_zoom_2.json",
         "android-runner/config/config_zoom_1.json",
         #"android-runner/config/config_zoom_3.json",
         #"android-runner/config/config_zoom_4.json",
         
        
    ]

    for config in configs:
        args = ["python3", "android-runner"]
        args.append(config)
        proc = subprocess.Popen(args)
        proc.wait()


if __name__ == '__main__':
    main()
