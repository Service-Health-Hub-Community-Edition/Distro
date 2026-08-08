# Azure DevOps Project

## Overview

Azure DevOps provides services that help organizations plan work, collaborate on software development, and build and deploy applications. It supports a culture and set of processes that bring together developers, project managers, and other contributors to deliver solutions efficiently.

Microsoft Service Health Hub integrates with Azure DevOps to support change management processes by creating, assigning, and tracking work items generated from service communications and platform updates.

## Azure Boards

Azure Boards is the work tracking service within Azure DevOps.

It provides a comprehensive set of capabilities for managing work, including:

- Scrum support
- Kanban boards
- Customizable dashboards
- Backlog management
- Integrated reporting
- Work item tracking
- Team collaboration

These capabilities enable organizations to scale their project and change management processes as business requirements evolve.

## Work Item Management

Azure Boards allows teams to quickly create and manage work items related to operational changes, incidents, feature releases, and service communications.

Work can be tracked through:

- Product Backlogs
- Sprint Backlogs
- Task Boards
- Kanban Boards
- Queries and Reports

Work items are created using the process and work item types configured for the Azure DevOps project.

Service Health Hub uses Azure DevOps to automatically create and update work items for relevant service communications, helping teams:

- Track service changes
- Assign ownership
- Monitor implementation activities
- Manage release readiness
- Record change management activities
- Maintain auditability and reporting

## Azure DevOps Requirements

Before integrating Microsoft Service Health Hub with Azure DevOps, ensure that:

- An Azure DevOps organization exists
- An Azure DevOps project has been created
- The project uses the Service Health Hub inherited process
- Required permissions have been assigned
- Service Health Hub service principals have access to the project

For Azure DevOps documentation, see:

https://learn.microsoft.com/en-us/azure/devops

---

**Previous:** [Run the deployment script](../deployment/resource-deployment.md)

**Next:** [Create an Azure DevOps process](./create-azure-devops-process.md)