# This ps script triggers a data factory pipeline run and monitors the status. Could be used in release pipeline to test data factory pipeline run after deployment.  
[CmdletBinding()]
param(
    $resourceGroupName,
    $dataFactoryName,
    $DFPipelineName
    )

$RunId = Invoke-AzDataFactoryV2Pipeline `
  -DataFactoryName $DataFactoryName `
  -ResourceGroupName $ResourceGroupName `
  -PipelineName $DFPipeLineName 

      while ($True) {
          $Run = Get-AzDataFactoryV2PipelineRun `
              -ResourceGroupName $ResourceGroupName `
              -DataFactoryName $DataFactoryName `
              -PipelineRunId $RunId

            if ($Run) {
                    if ($run.Status -eq 'Succeeded') {
                        Write-Output ("Pipeline run finished. The status is: " +  $Run.Status)
                        $Run
                        break
                    }
                    if ($run.Status -eq 'Failed') {
                        Write-Error ("Pipeline run failed. " + $Run.Message )
                        $Run
                        break 
                    }
                    Write-Output ("Pipeline is running...status: " +  $Run.Status)
                }

                Start-Sleep -Seconds 10
            }