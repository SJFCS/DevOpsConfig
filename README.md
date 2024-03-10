## Usage
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/cloudnative-love)](https://artifacthub.io/packages/search?repo=cloudnative-love)

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:
```bash
helm repo add DevOpsConfig https://SJFCS.github.io/DevOpsConfig
```
If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages.  

You can then run `helm search repo DevOpsConfig` to see the charts.

To install the <chart-name> chart:
```bash
helm install my-<chart-name> DevOpsConfig/<chart-name>
```

