<#
.SYNOPSIS
   Create a menu for testing against AD log monitoring.  

.DESCRIPTION

.PARAMETER 

.PARAMETER ProfileAge

.EXAMPLE   

.EXAMPLE

.EXAMPLE

.NOTES
    Author:         Tad Sherrill
        
    2022-01-31:
        - Created test script
        - 

    01-06-2023:
        - Did future things

#>


$explainor      = 

                "This Tool is intended to test Graylog logging and alerting of AD actions."


$LogfilePath = "C:\Program Files\Graylog\test_eventID.txt"



<################### Menu Presentation and Choice ###############################>


function present_menu {
    param (
        [string]      $local:table_name    = 'unNamed',
        [hashtable]   $local:menu_hash
    )

    Clear-Host
    Write-Host 
    Write-Host "================ $local:table_name ==================="
    Write-Host 
    Write-Host $top_message -fore Green
    Write-Host  -f white

     $local:menu_hash.GetEnumerator() | sort-object -Property name  | foreach {
          Write-host $_.name: $_.value.menu_line
          Write-Host
    }
    Write-Host "Local Log File: " -f green -n; write-host $LogfilePath -f DarkGreen
    Write-Host  -f white
    if ($local:table_name -eq "Main Menu") {
        Write-Host "============= 'Q'uit ================"
    } else {
        Write-Host "=========== 'Q'uit or 'B'ack ==============="
    }
    Write-Host 

}


function present_choice   {    
    param (
        [parameter(Mandatory=$True)]
            $menu_name,
        [parameter(Mandatory=$True)]
            $hash_name,
        [parameter(Mandatory=$false)]
        $dummy_receiver
    )
        $all_choice = @{}
        $this_menu = $(& $hash_name)
        
        $all_choice = foreach ($choice in $this_menu.GetEnumerator()) {
            [string]$choice.name
        }  
        
        do {
            present_menu $menu_name $this_menu
            $decision  = Read-Host "Please make a selection"
            if ([regex]::Match($decision, "[q]").value) {exit}
            if ([regex]::Match($decision, "[b]").value) {break}
            if ($all_choice -contains $decision)  {
                $last_action = $this_menu.([int]$decision).menu_action
                $last_description = $this_menu.([int]$decision).menu_line.replace(" ","-").trim(".")
<#                invoke-expression -Command $this_menu.([int]$decision).menu_action  #>
                invoke-expression -Command "$last_action $last_description"
                $top_message = "Last action:  $last_action"
            }
        } until ([regex]::Match($decision, "[qb]").value) 
 
     return ($decision)
}



<################### Menu Builds ###############################>

function hash_main_menu {
    $menu_build = @{
        1 = @{
            menu_line     = "UnGrouped Tests..."
            menu_action   = 'present_choice UnGrouped_Tests hash_ungrouped'
        }
        2 = @{
            menu_line     = "Password Tests..."
            menu_action   = 'present_choice Pasword_Tests hash_password'
        }
        3 = @{
            menu_line     = "User Account Tests..."
            menu_action   = 'present_choice User_Tests hash_user'
        }
        4 = @{
            menu_line     = "Group Tests..."
            menu_action   = 'present_choice Group_Tests hash_group'
        }
        5 = @{
            menu_line     = "OU Tests..."
            menu_action   = 'present_choice OU_Tests hash_organizationalUnit'
        }
    }
    return($menu_build)
}

function hash_organizationalUnit {
    $menu_build = @{
        5137 = @{
            menu_line      = "LogTest: A directory service object maybe an OU was created"
            menu_action    = "test-actions 5137"
        }
        5141 = @{
            menu_line     = "LogTest: A directory service object maybe an OU was deleted"
            menu_action   = "test-actions 5141"
        }
        5136 = @{
            menu_line      = "LogTest: A directory service objec maybe an OU was modified"
            menu_action    = "test-actions 5136"
        }
        5139 = @{
            menu_line      = "LogTest: A directory service object maybe an OU was moved"
            menu_action    = "test-actions 5139"
        }

    }
    return($menu_build)
}

function hash_group {
    $menu_build = @{
        1 = @{
            menu_line      = "Group Deleted..."
            menu_action    = "present_choice Group_Delete_Tests hash_group_deleted"
        }
        2 = @{
            menu_line      = "Group Changed..."
            menu_action    = "present_choice Group_Change_Tests hash_group_changed"
        }
        3 = @{
            menu_line      = "Group created..."
            menu_action    = "present_choice Group_Create_Tests hash_group_created"
        }
        4 = @{
            menu_line      = "Group - New Member..."
            menu_action    = "present_choice Group_New_Member_Tests hash_group_newmember"
        }
        5 = @{
            menu_line      = "Group - Delete Member..."
            menu_action    = "present_choice Group_Delete_Tests hash_group_delmember"
        }
    }
    return($menu_build)
}

function hash_group_delmember {
    $menu_build = @{
        4733 = @{
            menu_line      = "LogTest: A member was removed from a security-enabled local group"
            menu_action    = "test-actions 4733"
        }
        4729 = @{
            menu_line      = "LogTest: A member was removed from a security-enabled global group"
            menu_action    = "test-actions 4729"
        }
        4757 = @{
            menu_line      = "LogTest: A member was removed from a security-enabled universal group"
            menu_action    = "test-actions 4757"
        }
        4747 = @{
            menu_line      = "LogTest: A member was removed from a security-disabled local group"
            menu_action    = "test-actions 4747"
        }
        4752 = @{
            menu_line      = "LogTest: A member was removed from a security-disabled global group"
            menu_action    = "test-actions 4752"
        }
        4762 = @{
            menu_line      = "LogTest: A member was removed from a security-disabled universal group"
            menu_action    = "test-actions 4762"
        }
    }
    return($menu_build)
}

function hash_group_newmember {
    $menu_build = @{
        4732 = @{
            menu_line      = "LogTest: A member was added to a security-enabled local group"
            menu_action    = "test-actions 4732"
        }
        4728 = @{
            menu_line      = "LogTest: A member was added to a security-enabled global group"
            menu_action    = "test-actions 4728"
        }
        4756 = @{
            menu_line      = "LogTest: A member was added to a security-enabled universal group"
            menu_action    = "test-actions 4756"
        }
        4746 = @{
            menu_line      = "LogTest: A member was added to a security-disabled local group"
            menu_action    = "test-actions 4746"
        }
        4751 = @{
            menu_line      = "LogTest: A member was added to a security-disabled global group"
            menu_action    = "test-actions 4751"
        }
        4761 = @{
            menu_line      = "LogTest: A member was added to a security-disabled universal group"
            menu_action    = "test-actions 4761"
        }
    }
    return($menu_build)
}

function hash_group_created {
    $menu_build = @{
        4731 = @{
            menu_line      = "LogTest: A security-enabled local group was created"
            menu_action    = "test-actions 4731"
        }
        4727 = @{
            menu_line      = "LogTest: A security-enabled global group was created"
            menu_action    = "test-actions 4727"
        }
        4754 = @{
            menu_line      = "LogTest: A security-enabled universal group was created"
            menu_action    = "test-actions 4754"
        }
        4744 = @{
            menu_line      = "LogTest: A security-disabled local group was created"
            menu_action    = "test-actions 4744"
        }
        4749 = @{
            menu_line      = "LogTest: A security-disabled global group was created"
            menu_action    = "test-actions 4749"
        }
        4759 = @{
            menu_line      = "LogTest: A security-disabled universal group was created"
            menu_action    = "test-actions 4759"
        }
    }
    return($menu_build)
}

function hash_group_deleted {
    $menu_build = @{
        4734 = @{
            menu_line      = "LogTest: A security-enabled local group was deleted"
            menu_action    = "test-actions 4734"
        }
        4730 = @{
            menu_line      = "LogTest: A security-enabled global group was deleted"
            menu_action    = "test-actions 4730"
        }
        4758 = @{
            menu_line      = "LogTest: A security-enabled universal group was deleted"
            menu_action    = "test-actions 4758"
        }
        4748 = @{
            menu_line      = "LogTest: A security-disabled local group was deleted"
            menu_action    = "test-actions 4748"
        }
        4753 = @{
            menu_line      = "LogTest: A security-disabled global group was deleted"
            menu_action    = "test-actions 4753"
        }
        4763 = @{
            menu_line      = "LogTest: A security-disabled universal group was deleted"
            menu_action    = "test-actions 4763"
        }
    }
    return($menu_build)
}

function hash_group_changed {
    $menu_build = @{
        4735 = @{
            menu_line      = "LogTest: A security-enabled local group was changed"
            menu_action    = "test-actions 4735"
        }
        4737 = @{
            menu_line      = "LogTest: A security-enabled global group was changed"
            menu_action    = "test-actions 4737"
        }
        4755 = @{
            menu_line      = "LogTest: A security-enabled universal group was changed"
            menu_action    = "test-actions 4755"
        }
        4745 = @{
            menu_line      = "LogTest: A security-disabled local group was changed"
            menu_action    = "test-actions 4745"
        }
        4750 = @{
            menu_line      = "LogTest: A security-disabled global group was changed"
            menu_action    = "test-actions 4750"
        }
        4760 = @{
            menu_line      = "LogTest: A A security-disabled universal group was changed"
            menu_action    = "test-actions 4760"
        }
    }
    return($menu_build)
}

function hash_user {
    $menu_build = @{
        4720 = @{
            menu_line      = "Logtest: Create new USER"
            menu_action    = "test-actions 4720"
        }
        4726 = @{
            menu_line      = "LogTest: Delete USER"
            menu_action    = "test-actions 4726"
        }
        4722 = @{
            menu_line      = "LogTest: User Account ENABLED"
            menu_action    = "test-actions 4722"
        }
        4725 = @{
            menu_line      = "LogTest: User Account DISABLED"
            menu_action    = "test-actions 4725"
        }
        4781 = @{
            menu_line      = "LogTest: User Name Change"
            menu_action    = "test-actions 4781"
        }
        4738 = @{
            menu_line      = "LogTest: User Account Changed [not production alerted]"
            menu_action    = "test-actions 4738"
        }
        4740 = @{
            menu_line      = "LogTest: User account locked"
            menu_action    = "test-actions 4740"
        }
        4767 = @{
            menu_line      = "LogTest: User account UN-locked"
            menu_action    = "test-actions 4767"
        }

     }
    return($menu_build)
}

function hash_ungrouped {
    $menu_build = @{
        1 = @{
            menu_line      = "LogTest: Custom Key Value Line."
            menu_action    = "custom_log"
        }
        1074 = @{
            menu_line     = "LogTest: Machine Reboot Notification"
            menu_action   = "test-actions 1074"
        }
        4624 = @{
            menu_line      = "LogTest: Admin Account Used [Custom]"
            menu_action    = "test-actions 4624"
        }

    }
    return($menu_build)
}

function hash_password {
    $menu_build = @{
        4625 = @{
            menu_line      = "LogTest: Bad Password"
            menu_action    = "test-actions 4625"
        }
        4723 = @{
            menu_line      = "LogTest: User Password Change"
            menu_action    = "test-actions 4723"
        }
        4724 = @{
            menu_line      = "LogTest: Attempt to reset password + possibly Admin"
            menu_action    = "test-actions 4724"
        }
        4771 = @{
            menu_line      = "LogTest: Bad Password [Kerberos pre-auth fail] - NOALERT"
            menu_action    = "test-actions 4771"
        }
        4820 = @{
            menu_line      = "LogTest: Bad Password [Kerberos - TGT fail access control restrictions] - NOALERT"
            menu_action    = "test-actions 4820"
        }

    }
    return($menu_build)
}




<################### Supporting Functions ###############################>

Function DomAdmin-Check {

    $CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($CurrentUser)
    
    if($WindowsPrincipal.IsInRole("Domain Admins")){
        Return ("$($currentUser.Name) is a Domain Admin")
    }else{
        Write-Host "$($currentUser.Name) not a Domain Admin. Stopping All" -fore Red
        exit
    }

}

Function test-actions {
    param(
        [parameter(Mandatory=$True)]
            [string]$test_event_ID,
        [parameter(Mandatory=$True)]
            [string]$test_name
     )


    <# Common key_value items to include - comma after all but last#>
    $key_items          = "  TEST                              = TRUE,
                             winlog_event_id                   = $test_event_ID,
                             winlog_event_data_TargetUserName  = test-target-user-name,
                             winlog_event_data_SubjectUserName = test-subject-user-name,
                             event_detail                      = Test-EventID-$test_event_ID-$test_name
                          "
<#
    - If you have extra commands to add to a particular Event_ID, add them to the switch below

#>
     Switch -regex ($test_event_ID) {

        "4624" { 
           $key_items = $key_items -replace "test-target-user-name","administrator"
        }        
        "4625" { 
           $key_items += " ,winlog_host_name                  = your_HOST_name,
                            winlog_event_data_LogonType       = 11,
                            winlog_event_data_SubStatus       = 0xC0000225,
                            winlog_event_SubjectDomainName    = your_DOMAIN,
                            winlog_event_data_WorkstationName = your_WORKSTATION
                         "
        }        
        "4723" { 
           $key_items += " ,winlog_event_SubjectDomainName    = your_DOMAIN,
                            winlog_computer_name              = your_WORKSTATION
                         "
        }        
        "^(4771|4820)$" { 
           $key_items += " ,winlog_event_data_IpAddress       = 10.10.10.10,
                            winlog_event_data_Status          = 0xC0000225,
                            winlog_host_name                  = your_HOST_name,
                            event_digest                      = $test_name
                         "
        }        
        "1074" { 
           $key_items += " ,winlog_event_data_param5          = action.restart,
                            winlog_event_data_param7          = user.who.did.action,
                            winlog_event_data_param3          = Operating System: Reconfiguration [Unplanned]
                         "
        }        
        "^(4734|4730|4758|4748|4753|4763)$" { 
           <# Event ID's for deleted groups #>
        }
        "^(4735|4737|4755|4745|4750|4760)$" { 
           <# Event ID's for changed groups #>
        }
        "^(4731|4727|4754|4744|4749|4759)$" { 
           <# Event ID's for new Group Created #>
        }
        "^(4732| 4728|4756|4746|4751|4761)$" { 
           <# Event ID's for New Group Member #>
        }
        "^(4733|4729|4757|4747|4752|4762)$" { 
           <# Event ID's for Group Member Delete #>
        }
     }

    <# Clear all the stuff that makes the above key_items thing look nice and add back in spaces to the Value side for all dashes
            OF NOTE:  If there are dashes on the Key side that get converted to spaces the command will fail since keys can't have spaces.
     #>
    $key_items = $key_items -replace "`t|`n|`r| ",""
    $key_items = $key_items -replace "-"," "



    <# Places log message into file #>
    $key_items | out-file $LogfilePath -encoding UTF8 -append  ;pause

}

Function custom_log {

    $custom_log_line = ""

    do {
        Clear-Host
        Write-Host 
        Write-Host "================ Custom Message ==================="
        Write-Host 
        Write-Host "Current Custom Log: $custom_log_line"
        Write-Host 
        Write-Host "You can enter a custom log message here.   Key=value format is preferred."
        Write-host
        Write-host "enter Q into key value to finish"

        Write-host 
        $key_v = @{
            my_key   = read-host -Prompt 'Enter key'
            my_value = read-host -Prompt 'Enter value'
        }
        if ($($key_v.my_key) -match " ") {

            write-host "No spaces allowed in KEY portion"
            pause
        
        } elseif ($($key_v.my_key) -match "q"){
            break
        } else {
            $custom_log_line = "$custom_log_line,$($key_v.my_key)=$($key_v.my_value)"
        }


    } while ($($key_v.my_key) -notmatch "q")

    Write-Host "Proposed log message: $custom_log_line"
    $send_it = read-host -prompt "Send this log line? (y/N)"
    if ($send_it -match "y" ) {
        $custom_log_line.Trim(",") | out-file $LogfilePath -encoding UTF8 -append
        $top_message = "Custom Log Line: $custom_log_line"
    }
    

    Write-Host -f white
    Write-Host 

}



<# Main #>
    $top_message  = DomAdmin-Check
    $decision     = present_choice "Main Menu" hash_main_menu

