#!/usr/bin/env bash
# Runs SourceXtractor++ (conda image) on every FITS file in samples/.
# Images are tile-compressed with pixels in HDU 1 (flux in nJy, so AB zero point = 31.4).
set -euo pipefail

cd "$(dirname "$0")"
IMAGE=sourcextractor:1.1.0-conda
mkdir -p output

docker build -q -f conda_sourcextractor_1_1_0.Dockerfile -t "$IMAGE" . >/dev/null

for path in samples/*.fits; do
  name=$(basename "$path" .fits)
  echo "== $name"
  docker run --rm --platform linux/amd64 \
    -v "$PWD/samples:/data:ro" -v "$PWD/output:/output" \
    "$IMAGE" sourcextractor++ \
      --detection-image "/data/$name.fits[1]" \
      --magnitude-zero-point 31.4 \
      --output-catalog-filename "/output/${name}_cat.fits" \
      --output-properties SourceIDs,PixelCentroid,WorldCentroid,IsophotalFlux,AutoPhotometry,ShapeParameters,SourceFlags,NDetectedPixels \
      --check-image-segmentation "/output/${name}_seg.fits" \
      --check-image-background "/output/${name}_bkg.fits" \
      --thread-count 4 \
      "$@"
done
