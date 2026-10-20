#requires -Version 7.0

$processos = Get-Process | Sort-Object ProcessName, Id

foreach ($proces in $processos) {
    Write-Output "============================== $($proces.ProcessName) ($($proces.Id)) =============================="
    Write-Output ''

    try {
        $fils = @($proces.Threads)
    } catch {
        Write-Output 'Total threads: no disponible'
        Write-Output 'El procés ha acabat o no es poden consultar els seus fils.'
        Write-Output ''
        continue
    }

    Write-Output "Total threads: $($fils.Count)"
    Write-Output ''

    foreach ($fil in $fils) {

        try {
            $tempsCPU = $fil.TotalProcessorTime
            if ($null -eq $tempsCPU) {
                $tempsCPU = 'No disponible'
            }
        } catch {
            $tempsCPU = 'No disponible'
        }
        Write-Output "ID: $($fil.Id) CPU TIME: $tempsCPU"
    }

    Write-Output ''
}
