@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'xFOCluster.psm1'

    # Version number of this module.
    ModuleVersion = '0.1.0.0'

    # ID used to uniquely identify this module
    GUID = '20d8cbd5-2e77-4a37-bc62-eecf4ed19520';

    # Author of this module
    Author = 'Pedro Wood <mail_pedro@yahoo.com>';

    # Description of the functionality provided by this module
    Description = 'This module contains DSC resources that enable management of Failover Cluster.';

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0';

    # Required for DSC to detect PS class-based resources.
    DscResourcesToExport = @(
        'xFOCluster';
        );
}
