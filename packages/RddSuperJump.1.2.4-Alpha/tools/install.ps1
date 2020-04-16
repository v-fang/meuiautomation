param($installPath, $toolsPath, $package, $project)
$Webconfig = $project.ProjectItems | where { $_.Name -eq 'Web.config' }
if($Webconfig -eq $null)
{
    Write-Host 'Web.config not exist, may be the type of your project is not supported.' -BackgroundColor Yellow
    return
}
$webCfgFile = $Webconfig.FileNames(1)
$projectRootDir =  Split-Path $webCfgFile  -Parent
function Set-RenderSection
{	
	$sectionPartsxml=[xml](Get-Content (join-path $installPath 'content\SectionParts.xml'))
	$layoutFilePath=Join-Path $projectRootDir 'Views\Shared\_Layout.cshtml'
	if( -not (Test-Path $layoutFilePath))
	{
		Write-Host "Your project type is not MVC so we can''t deal with it." -BackgroundColor Yellow#
	}
	else {
		
		 # 1.Modify the _Layout.cshtml
			$layoutCode=($sectionPartsxml.ModifyFiles['_Layout.cshtml']).InnerText
#		 $regex1=[regex]"<body>"
#		 $regex1.Matches((Get-content $layoutFilePath))
			$layoutFile=Get-content $layoutFilePath
            $tmpLayoutFile=$layoutFile.Replace("<body>",$layoutCode)
            Set-Content $layoutFilePath $tmpLayoutFile
            }
}
Set-RenderSection