import os
import json
import csv

# Configuration
phone = "pixel3"
raw_data_path = "/Volumes/Seagate HDD/VU/Green Lab/data-pre"

# The results will be pushed here before writing them into a csv file at the end
result_rows = []

# For all folders in the raw data directory:
folders = os.listdir(raw_data_path)
for folder in folders:
    # Read config.json to obtain app name and duration
    config = json.load(open(os.path.join(raw_data_path, folder, "config.json"),))
    app_name = config["apps"][0]
    duration = config["duration"]
    
    # Determine path and file names of energy log files
    log_files_path = os.path.join(raw_data_path, folder, "data", phone, app_name.replace(".", "-"), "batterystats")
    all_log_files = os.listdir(log_files_path)
    joules_log_files = [f for f in all_log_files if f.startswith("Joule")]
    
    # For all energy measurement log files:
    for file in joules_log_files:
        with open(os.path.join(log_files_path, file)) as csv_file:
            # Read measured energy consumption for each log file
            joules_rows = list(csv.reader(csv_file, delimiter=','))
            joule_value = joules_rows[1][0]

            # Replace the app package by either "Meet" or "Zoom"
            formatted_app_name = {
                "com.google.android.apps.meetings": "Meet",
                "us.zoom.videomeetings": "Zoom"
            }[app_name]

            duration_in_minutes = duration / 60000

            # Create a row for each measurement
            result_rows.append({
                "app": formatted_app_name,
                "duration_in_minutes": duration_in_minutes,
                "joules": joule_value
            })

# Write results to a CSV file
with open(os.path.join(raw_data_path, "..", "results-pre.csv"), "w") as f:
    writer = csv.DictWriter(f, fieldnames=["app", "duration_in_minutes", "joules"])
    writer.writeheader()
    writer.writerows(result_rows)

print("Done.")