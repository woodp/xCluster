enum Ensure {
    Absent;
    Present;
}

[DscResource()]
class xFOCluster {
    <#
    The Ensure property is used to determine if the Failover Cluster should be installed (Present) or not installed (Absent).
    #>
    [DscProperty(Mandatory)]
    [Ensure] $Ensure;

    <#
    Name of the Failover Cluster.
    #>
    [DscProperty(key)]
    [string] $ClusterName;

    <#
    List of cluster node names, separated by commas, on which to create the cluster. If this parameter is not specified, then a one node cluster is created on the local physical computer
    #>
    [DscProperty(Mandatory)]
    [string] $Nodes;

    <#
    Specifies one or more static addresses to use, separated by commas
    #>
    [DscProperty()]
    [string] $StaticAddress

    [xCluster] Get() {

        Write-Verbose -Message 'Start retriving Failover Cluster info.';

        try {
            Get-Cluster -Name $this.ClusterName -ErrorAction Stop;
        }
        catch {
            Write-Verbose -Message ('Error occurred while retrieving Failover Cluster: {0}' -f $global:Error[0].Exception.Message);
        }

        Write-Verbose -Message 'Finished retrieving Failover Cluster info.';
        return $this;
    }

    [System.Boolean] Test() {

        Write-Verbose -Message 'Testing for presence of a Failover Cluster.';
        $Cluster = $null;
        try {
            $Cluster = Get-Cluster -Name $this.ClusterName -ErrorAction Stop;
        }
        catch {
            
        }

        if ($this.Ensure -eq 'Present') {
            Write-Verbose -Message 'Checking for presence of Failover Cluser.';
            if ($Cluster -ne $null) {
                return $false;
            }
            return $true;
        }

        if ($this.Ensure -eq 'Absent') {
            Write-Verbose -Message 'Checking for absence of Failover Cluster.';
            if ($Cluster -ne $null) {
                return $true;
            }
            return $false;
        };

        return $true;
    }

    [void] Set() {

        if ($this.Ensure -eq [Ensure]::Present) {
            Write-Verbose -Message 'Creating Cluster.'
            if($this.StaticAddress -eq $null){
                New-Cluster -Name $this:ClusterName -Node $this:Nodes -NoStorage -Force -ErrorAction Stop
            } else {
                New-Cluster -Name $this:ClusterName -Node $this:Nodes -StaticAddress $this.StaticAddress -NoStorage -Force -ErrorAction Stop
            }
        }

        if ($this.Ensure -eq [Ensure]::Absent) {
            Write-Verbose -Message 'Removing Cluster.'
            try {
                Get-Cluster -Name $this:ClusterName | Remove-Cluster -Force -CleanupAD
            }
            catch { }
        }

        return;
    }
}