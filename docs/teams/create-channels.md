## Creating channels

The solution is configured to route notifications to the appropriate Teams channels based on your requirements.

Channels receive adaptive cards according to the routing configuration that is configured later in the **Service Health Hub Admin Center**.

We recommend creating one **Microsoft Service Health Hub Admin** team in addition to the team and channels used for service communications.

The **Microsoft Service Health Hub Admin** team should contain the following channels:

- **Issues**  
  Contains error messages for issues that occur during data synchronization and provides real-time insight into synchronization problems.

- **Weekly digest**  
  Contains the weekly summary of synchronization jobs.

For the **Microsoft Service Health Hub** team, create channels according to the customer requirements.

A sample list of channels is provided in [Appendix A - Sample list of Microsoft Service Health Hub team channels](../appendix/appendix-a-sample-list-of-teams-channels.md).

> **NOTE**: 
> Follow the instructions in the Microsoft Support article to create standard channels:
>
> <https://support.microsoft.com/en-us/office/create-a-channel-in-teams-fda0b75e-5b90-4fb8-8857-7e102b014525>
>
> Shared and private channels are not supported.

---

**Previous:** [Create channels](./create-channels.md)

**Next:** [Create incoming webhooks](./create-incoming-webhooks.md)