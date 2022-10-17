#!/usr/bin/env python
from PIL import Image
import sys

file = sys.argv[1]
print('pixeling', file)
with Image.open(file) as img:
    # pixelate
    imgSmall = img.resize((int(img.size[0] / 10), int(img.size[1] / 10)), resample=Image.Resampling.BILINEAR)
    result = imgSmall.resize(img.size, Image.Resampling.NEAREST)
    result.save(file)
