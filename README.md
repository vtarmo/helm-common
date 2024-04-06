# helm-common chart

This is just library chart. Chart is for personal use. No support, no warranty. If you have questions, please do not hesitate to ask.

## update chart

```bash
helm package helm-common
mv helm-common-0.5.2.tgz docs
helm repo index docs --url https://vtarmo.github.io/helm-common
git add -i
git commit -av
git push origin master
```