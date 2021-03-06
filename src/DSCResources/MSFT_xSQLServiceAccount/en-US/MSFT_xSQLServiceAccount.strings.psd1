# Localized resources for xSQLServiceAccount

ConvertFrom-StringData @'
    ForceServiceAccountUpdate = Force specified, skipping tests. With this configuration, Test-TargetResource will always return 'False'.
    CurrentServiceAccount = Current service account is '{0}' for {1}\{2}.
    ConnectingToWmi = Connecting to WMI on '{0}'.
    UpdatingServiceAccount = Setting service account to '{0}' for service {1}.
    RestartingService = Restarting '{0}' and any dependent services.
    ServiceNotFound = The {0} service on {1}\\{2} could not be found.
    SetServiceAccountFailed = Unable to set the service account for {0} on {1}. Message {2}
'@
