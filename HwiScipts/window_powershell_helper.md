If you have exception like this:
...\windows_hwi.ps1 cannot be loaded because running scripts is disabled on this system. For more information, see about_E
xecution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
    + CategoryInfo          : SecurityError: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : UnauthorizedAccess





Run Ppowershell as Administration
 and write it:
	
Set-ExecutionPolicy RemoteSigned