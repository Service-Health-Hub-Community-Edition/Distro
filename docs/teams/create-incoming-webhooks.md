## Creating incoming webhooks

Now that the Teams structure is created, integration points must be enabled for each channel.

For each channel created in the previous step, create one **Power Automate incoming webhook workflow**. Each workflow provides a unique HTTP endpoint that Service Health Hub uses to send notification payloads to the corresponding Teams channel.

Follow the instructions in the Microsoft Support article:

<https://support.microsoft.com/en-us/office/create-incoming-webhooks-with-workflows-for-microsoft-teams-8ae491c7-0394-4861-ba59-055e33f75498>

Use the section **Set up an incoming webhook workflow from a template** to create the workflow for each channel.

> **IMPORTANT**: 
> Create **one incoming webhook workflow per Teams channel**.
>
> Each workflow URL represents exactly one Teams channel and must be used only for the corresponding notification routing rule.

After creating each workflow, copy the URI of the incoming webhook workflow trigger and store it in the temporary Excel spreadsheet. Track the following information:

| Team | Channel | Incoming webhook workflow URI |
|---|---|---|
| Microsoft Service Health Hub Admin | Issues | |
| Microsoft Service Health Hub Admin | Weekly digest | |
| Microsoft Service Health Hub | `<channel name>` | |

---

**Previous:** [Create channels](./create-channels.md)

**Next:** [Configure Azure Function](../configuration/azure-function.md)