## Configure admin notification rules

Service Health Hub admin notifications are configured in two different data sources:

- **Admin notifications**  
  Handles real-time notifications for synchronization issues and the weekly digest.

- **Microsoft Service Health Hub Releases**  
  Handles Microsoft Service Health Hub release announcements.

### Admin notifications

Create two rules for the **Admin notifications** data source.

#### Issues

Create a **catch-all** rule for synchronization issues.

Configure the following settings:

| Setting | Value |
|---|---|
| **Name** | `Issues` |
| **Conditions** | None |
| **Icon** | Select an appropriate icon |
| **Connector** | Microsoft Teams via webhook |
| **Connector configuration** | Incoming webhook workflow URL for the **Issues** channel |

Because this rule has no conditions, it matches all admin notifications that are not matched by a more specific rule.

#### Weekly digest

Create a rule for weekly digest notifications.

Configure the following settings:

| Setting | Value |
|---|---|
| **Name** | `Weekly digest` |
| **Conditions** | `Type` in `Weekly digest` |
| **Icon** | Select an appropriate icon |
| **Connector** | Microsoft Teams via webhook |
| **Connector configuration** | Incoming webhook workflow URL for the **Weekly digest** channel |

---

**Previous:** [Configure notification routing](./notification-routing.md)

**Next:** [Enable Service Health Hub jobs](../operations/enable-jobs.md)