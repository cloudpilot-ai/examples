# CloudPilot AI Examples

This repository contains various demonstration manifests for CloudPilot AI.

## Demonstration Clusters

- [EKS with managed onDemand node group](clusters/eks-ondemand): Create a demonstration cluster with an EKS managed onDemand node group for showcasing CloudPilot AI optimization.
- [EKS with managed onDemand node group in china region](clusters/eks-ondemand-cn): Create a demonstration cluster with an EKS managed nonDemand ode group for showcasing CloudPilot AI optimization in china region.
- [EKS with managed spot node group](clusters/eks-spot): Create a demonstration cluster with an EKS managed spot node group for showcasing CloudPilot AI optimization.
- [AKS with on-demand node pool](clusters/aks-ondemand): Create an AKS demonstration cluster with an on-demand node pool for showcasing CloudPilot AI optimization.
- [AKS with spot node pool](clusters/aks-spot): Create an AKS demonstration cluster with a spot user node pool for showcasing CloudPilot AI optimization.
- [ACK with spot instance nodes and terway cni](clusters/ack-spot-terway): Create an ACK demonstration cluster with spot instance nodes and terway cni for showcasing CloudPilot AI optimization.
- [ACK with onDemand instance nodes and terway cni](clusters/ack-ondemand-terway): Create an ACK demonstration cluster with onDemand instance nodes and terway cni for showcasing CloudPilot AI optimization.
- [ACK with spot instance nodes and flannel cni](clusters/ack-spot-flannel): Create an ACK demonstration cluster with onDemand instance nodes and flannel cni for showcasing CloudPilot AI optimization.

## AKS Notes

- AKS availability zone support varies by region, subscription, and VM size.
- If a zonal system pool is not supported in your environment, use the spot example in [clusters/aks-spot](clusters/aks-spot), which supports separate zone overrides for the `system` and `spot` node pools.

## License

[Apache 2.0 License](./LICENSE).
