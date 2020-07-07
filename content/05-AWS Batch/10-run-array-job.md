+++
title = "i. Run an Array Job"
date = 2019-09-18T10:46:30-04:00
weight = 110
tags = ["tutorial", "install", "AWS", "batch", "packer"]
+++

In this step, you submit many jobs at once, known as an [array job](https://docs.aws.amazon.com/batch/latest/userguide/array_jobs.html). To do so, you create a *JSON* file that contains the parameters of the job array.

1. In the following JSON file, modify the text to reflect your environment properties: Replace **YOUR-JOB-QUEUE-NAME** and **YOUR-JOB-DEFINITION-NAME** with the values of your job queue name and job definition name.

```bash
cat <<EOF > ./my-job.json
{
  "jobName": "my-job",
  "jobQueue": "YOUR-JOB-QUEUE-NAME",
  "arrayProperties": {
    "size": 500
  },
  "jobDefinition": "YOUR-JOB-DEFINITION-NAME"
}
EOF
```
2. Copy the contents of the JSON file and paste it into your terminal.
3. Submit the job array using the following command.
```bash
aws batch submit-job --cli-input-json file://my-job.json
```
You just launched an array job of 500 jobs! To learn more about job arrays, see [Tutorial: Using the Array Job Index to Control Job Differentiation](https://docs.aws.amazon.com/batch/latest/userguide/array_index_example.html).
