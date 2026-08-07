# Service Health Hub

> Always up to date. Always organized. One single place.

Service Health Hub is an open-source operational intelligence and change-management platform for Microsoft cloud services.

It centralizes service health events, product announcements, roadmap updates, and other service communications across Microsoft 365, Azure, Dynamics 365, and Power Platform. The platform transforms this information into actionable notifications, tasks, work items, reports, and searchable organizational knowledge.

## Why Service Health Hub?

Microsoft cloud environments generate a large volume of operational information across different portals and communication channels.

Organizations must continuously track:

- Service incidents and advisories
- Message Center announcements
- Upcoming product and feature changes
- Microsoft 365 Roadmap updates
- Azure service health events
- Dynamics 365 and Power Platform release information
- Microsoft 365 endpoint changes
- License usage and service adoption

Service Health Hub brings this information together and integrates it with the tools and processes already used by IT operations, service owners, administrators, developers, governance teams, and support organizations.

## Key Features

### Centralized Service Communications

Aggregate service communications and operational information from supported Microsoft cloud services into a single platform.

### Automated Notifications

Generate notifications for:

- Microsoft 365 service incidents and advisories
- Microsoft 365 Message Center announcements
- Microsoft 365 Roadmap changes
- Azure service health events
- Azure updates
- Dynamics 365 and Power Platform updates
- Microsoft 365 service IP and URL changes 

Notifications can be routed to the appropriate Microsoft Teams channels or other destinations.

### Task and Work Item Automation

Automatically create or update tasks, work items, or incidents in supported systems, including:

- Azure DevOps
- ServiceNow
- Jira
- Microsoft Planner
- Custom systems through Logic Apps or APIs

### Intelligent Routing and Filtering

Define routing and exclusion rules using service communication metadata.

This helps organizations:

- Notify only the teams responsible for the affected service
- Route tasks to the appropriate project, area, queue, or bucket
- Exclude services that are not used by the organization
- Apply organization-specific processing logic

### Communication Correlation

Link related Microsoft 365 Roadmap items and Message Center announcements in supported task-management systems.

This provides additional context and helps teams manage the lifecycle of upcoming service changes.

### Microsoft Teams Integration

Provide service health information, notifications, dashboards, and links to operational tasks through Microsoft Teams.

This makes relevant information available to stakeholders who may not have direct access to the Microsoft 365 Admin Center.

### Dashboards and Reporting

Provide centralized views for:

- Active incidents and advisories
- Upcoming Microsoft cloud changes
- Historical service health information
- Message Center and roadmap communications
- Microsoft 365 endpoint changes
- License statistics and forecasts
- Organization-specific service announcements

### Microsoft Search and Copilot Integration

Service communications can optionally be indexed through a Microsoft Graph connector so that authorized users can discover relevant information through Microsoft Search and supported Copilot experiences.

### Multilingual Processing

Service Health Hub can integrate with Azure AI services to translate and summarize service communications before notifications and tasks are created.

## Supported Data Sources

Depending on configuration, Service Health Hub can process information from:

- Microsoft 365 Service Health
- Microsoft 365 Message Center
- Microsoft 365 Roadmap
- Azure Service Health
- Azure Updates
- Dynamics 365 Release Planner
- Power Platform Release Planner
- Microsoft 365 endpoint information
- Organization-specific communication sources

## Supported Integrations

Service Health Hub supports integration with:

- Microsoft Teams
- Azure DevOps
- ServiceNow
- Jira
- Microsoft Planner
- Microsoft Graph
- Microsoft Search and Copilot connectors
- Azure Logic Apps
- Custom APIs and workflows

Integration availability depends on the installed components and configuration.

## Architecture

A typical Service Health Hub deployment can include:

- Azure Functions for synchronization and processing
- Azure SQL Database for configuration and operational data
- Azure Key Vault for secret management
- Microsoft Entra ID for authentication and authorization
- Azure App Service for the web application
- Azure Monitor for operational monitoring
- Microsoft Graph for Microsoft 365 service communications
- Azure AI Translator for multilingual content
- Azure AI Language for content summarization
- Microsoft Teams for notifications and collaboration
- Azure DevOps, ServiceNow or Jira for task management

## How It Works

The synchronization process generally follows these stages:

1. Retrieve service communications from supported APIs.
2. Compare the retrieved data with previously processed information.
3. Identify new or updated items.
4. Translate or summarize content when configured.
5. Create or update tasks in the target system.
6. Apply notification-routing rules.
7. Send notifications to the appropriate destinations.
8. Store synchronization state and operational metadata.
9. Optionally index content for Microsoft Search and Copilot.

## Use Cases

Service Health Hub can help organizations with:

- Microsoft 365 evergreen change management
- Cloud service incident awareness
- IT service-management integration
- Service-owner notification and accountability
- Governance and compliance transparency
- Microsoft 365 Copilot readiness
- Works council and stakeholder communication
- Cloud operations reporting
- License monitoring and forecasting
- Centralized discovery of service communications

## Project Status

Service Health Hub is now a community-driven open-source project.

Interfaces, deployment procedures, integration options, and documentation may change as the project evolves.

## Getting Started

Deployment and configuration includes:

- Architecture overview
- Prerequisites
- Azure deployment
- Microsoft Entra ID configuration
- Microsoft Graph permissions
- Database setup
- Notification configuration
- Routing and exclusion rules
- Task-management integrations
- Microsoft Teams integration
- Microsoft Search and Copilot connector configuration
- Monitoring and troubleshooting
- Upgrade guidance

## Documentation

Project documentation is available in the ./docs directory.

> Documentation will be expanded as components are prepared for public release.

## Security

Do not store credentials, client secrets, certificates, connection strings, tenant information, or customer data in the repository.

Use supported secret-management mechanisms such as Azure Key Vault or environment-specific application settings.

For security issues, follow the instructions in ./SECURITY.md.

## Contributing

Contributions are welcome.

Before contributing, review:

- ./CONTRIBUTING.md
- ./CODE_OF_CONDUCT.md
- ./SECURITY.md

You can contribute by:

- Reporting bugs
- Proposing new features
- Improving documentation
- Adding integrations
- Submitting fixes
- Sharing deployment experiences

## Disclaimer

Service Health Hub Community Edition is a community project and is not an official Microsoft product or support offering.

The software and documentation are provided without warranties or guarantees. Organizations are responsible for reviewing the solution, its permissions, security configuration, compliance requirements, operational impact, and suitability before deployment.

Microsoft, Microsoft 365, Azure, Dynamics 365, Power Platform, Microsoft Teams, Microsoft Entra, and other Microsoft product names are trademarks of the Microsoft group of companies.

## License

This project is licensed under the terms described in the ./LICENSE file.

## Feedback and Support

Use GitHub Issues to:

- Report defects
- Request features
- Ask documentation questions
- Propose integrations
- Share feedback

Please do not include credentials, tenant identifiers, customer data, personal data, or other confidential information in GitHub issues.
