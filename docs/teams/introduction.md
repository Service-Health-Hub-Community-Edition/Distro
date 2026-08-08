# Teams configuration

**Microsoft Teams** is the hub for team collaboration in Microsoft 365. It brings together people, conversations, content, and tools so teams can collaborate in one place.

Service Health Hub uses Microsoft Teams channels to deliver notifications to the right audience. Notifications are sent as adaptive cards and routed to channels based on the notification routing rules configured later in the Service Health Hub Admin Center.

Service Health Hub uses **Power Automate workflows with incoming webhook triggers**. Each Teams channel that should receive notifications requires its own Power Automate workflow.

The workflow provides a unique HTTP endpoint. Service Health Hub sends the notification payload to that endpoint, and the workflow posts the message into the corresponding Teams channel.

> **IMPORTANT**: 
> Create **one Power Automate incoming webhook workflow per Teams channel**.
>
> Each workflow URL must be stored separately and later used in the corresponding Service Health Hub notification routing rule.

Adaptive cards are user-interface containers that present notification content and actions in a consistent format. Service Health Hub uses adaptive cards to display service health incidents, updates, releases, synchronization issues, and weekly digest information in Microsoft Teams.

---

**Previous:** [Create an Azure DevOps project](../azure-devops/create-azure-devops-project.md)

**Next:** [Create one or more teams](./create-team.md)