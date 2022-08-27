---
title: "h. Prepare Training Data"
date: 2022-08-27
weight: 90
---

For the model training part of the workshop, we will use the Tiny ImageNet dataset which consists of 100000 images of 200 classes. We can download the data directly to the FSxL filesystem mounted to all the nodes in the cluster. We created the mount directory (`/fsx`) when creating the AMI in step **e**. Executing the following command will run wget on the head node to download the data to `/fsx` directory:

```bash
ray exec cluster.yaml 'wget http://cs231n.stanford.edu/tiny-imagenet-200.zip -P /fsx/'
```

Next, unzip the data file residing in the `/fsx` directory:

```bash
ray exec cluster.yaml 'unzip -d /fsx /fsx/tiny-imagenet-200.zip && rm /fsx/tiny-imagenet-200.zip'
```

We can check the contents of the data directory executing `ls` command on head node:

```bash
ray exec cluster.yaml 'ls /fsx/tiny-imagenet-200'
```

In our training code, we will use ImageFolder class from PyTorch to ingest this dataset. The ImageFolder class expects all the images to be stored in separate folders for each class. The structure should look like this:

```
.
|-- train
|   |-- class1
|   |   |-- image1.jpeg
|   |   |-- image2.jpeg
|   |   |-- image3.jpeg
.
|   |-- class2
|   |   |-- image1.jpeg
|   |   |-- image2.jpeg
|   |   |-- image3.jpeg
.
.
```

The `val` folder in the Tiny ImageNet dataset does not have this structure, so we have to rearrange the images in the val directory. This can done by running a simple python script. Copy the following code to **data-prep.py** file:

```python
import os
import ray

def main():
    ray.init(address="auto")

    root_dir = '/fsx/tiny-imagenet-200/val/'
    annotation_file = 'val_annotations.txt'
    with open(root_dir + annotation_file) as f:
        """
        lines in the val_annotations.txt file:
        val_0.JPEG      n03444034       0       32      44      62
        val_1.JPEG      n04067472       52      55      57      59
        val_2.JPEG      n04070727       4       0       60      55
        """
        lines = f.read().split('\n')
        lines = lines[:-1] # last line is empty

    data = {}
    for line in lines:
        file, label = line.split('\t')[:2]
        data[file] = label

    # create the directories. labels are the directory names
    labels = set(data.values())
    for label in labels:
        os.mkdir(root_dir + label)

    # move files from images folder to the new directories
    for file in data:
        src = root_dir + 'images/' + file
        dst = root_dir + '/' + data[file] + '/' + file
        os.replace(src, dst)

    os.rmdir(root_dir + 'images')
    os.remove(root_dir + annotation_file)

if __name__ == "__main__":
    main()
```

Finally, execute this code on the ray cluster:
```bash
ray submit cluster.yaml data-prep.py
```
