# Graylog_Beats_EventID_testing
Menued system for throwing Windows EventID's to a Graylog beats via filebeatInput

This extensible powershell script will write to a predefined local text file the basic elements of key event ID's that I was interested in at the time of writing.

Since Graylog and underlying opensource can change how Graylog handles event or how Elasticsearch names fields I have occasionaly run into issues where Alerting stops.   Graylog is not required for this script, it simply writed eventIDs to a text log file in key_value style.



## Prerequisites if you are doing a Graylog:
1) Elasticsearch Beats Input on Graylog
2) Windows test machine with sidecar and filebeat/NXlog set up - you will run the powershell script on this machine.
3) Test file to throw EventIDs and associated fields to (Currently:  "C:\Program Files\Graylog\test_eventID.log")
3) Collector to assign to test Windows machine.  Base collector file included.
4) Pipeline rule to break out the test message to it's constituent fields - set up to parse key_value fields (Rule included)

## How it works when you run the script:
   - Choose from the menu items which area you want to test by selecting the number and pressing enter to go into it
   - Choices of Event_IDs are listed by their EventID number. Sub menu's have "..." following their names
   - When you put in an event ID number, that event will be written to the local log file (listed in prerequisites #2)
   - Your filebeat should pick up the new log and ship it to the beats input on your Graylog server
   - You have a pipeline attached to the beats input that uses the "Testing eventID - set fields" rule that breaks out the key_values int he message and either shunts it to another stream/index or allows it to pass on through your other pipeline rules for Event_ID's

#### Main Menu looks similar to the following
```powershell
================ Main Menu ===================

<Username> is has sufficient privs

1 : UnGrouped Tests...

2 : Password Tests...

3 : User Account Tests...

4 : Group Tests...

5 : OU Tests...

Local Log File: C:\Program Files\Graylog\test_eventID.txt

============= 'Q'uit ================

Please make a selection: 
```

## Extra things to know about how this all works
### Sidecar Configuration File (Graylog)
If you want to have custom fields w/data inserted into all messages you can modify the Sidecar Configuration file.  Here is the portion that adds in for fields that are standard/checked in the EventID environment
```yaml
processors:
  - add_fields:
      target: ''
      fields:
        winlog_api:     wineventlog
        log_level:      information
        winlog_channel: Security
        winlog_task:    test_eventID
```

### Custom logfile messages
You can create a custom key_value message using

`UnGrouped Tests...` -> 
	`1 : LogTest: Custom Key Value Line.` 

  You will be prompted for each key and it's corresponding value until you put **Q** in for a Key.



## FAQ - NATQY (Nobody Asked This Question Yet) :grin:

### 1. What are the fields/data included by default in a test message?  See the following... (where $test_name is equal tot he title of the EventID menu selected...)
```
TEST                                = TRUE
winlog_event_id                     = $test_event_ID
winlog_event_data_TargetUserName    = test-target-user-name
winlog_event_data_SubjectUserName   = test-subject-user-name
event_detail                        = Test-EventID-$test_event_ID-$test_name
```

### 2. Where did you get this Event_ID information?
From [Randy Franklin Smith's excellent web site](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/default.aspx) of course!

### 3. How can I change the path/name of the local beats file that the powershell writes to?

Change the path and name in the Filebeat Configuration file
```
filebeat:
  inputs:
	- type: log
	  paths:
		- C:\Program Files\Graylog\test_eventID.txt	   
```
Then change the path at the top of the powershell script
```
$LogfilePath = "C:\Program Files\Graylog\test_eventID.txt"
```

### 4.  How can I and an eventID that I am interested in to the menu system?
All of the powershell functions that build the menus begin witht he word _hash_ and are descriptive for their functionality i.e _hash_group_delmember_ is a menu that had eventID's accocated with deleting members from a security or distribution group.  You can modify these menus or create new ones cloning the existing menus and either add a pointer to it in the main menu or an a sub menu.  Each has line item has two tibits of information in them and can work as a pointer to a new menu using the function _present_choice()_ or as a call to an eventID message using the funtion _test_actions()_ 

#### Examples:

##### - Generic hash line where XXXX is either the menu choice or the eventID
```
		XXXX = @{
			menu_line      = "<this is the Menu name **OR** the contents of the _event_detail_ field>"
			menu_action    = "<A call to the next menu with _present_choice_ **OR** a call to an eventID test with _test_actions_ >"
		}
```
##### - Example hash line where option _1_ Presents a menu item _"Group Deleted..."_ and calls to another menu with a menu name of _"Group_Delete_Tests"_  using the hash menu build of _hash_group_deleted_
```
		1 = @{
			menu_line      = "Group Deleted..."
			menu_action    = "present_choice Group_Delete_Tests hash_group_deleted"
		}
```
##### - Example hash line that will send a message to the log file where the menu choice and (when chosen) the _EventID_ field is 4730 and the _event_detail_ field will contain "LogTest: A security-enabled global group was deleted" 
        4730 = @{
            menu_line      = "LogTest: A security-enabled global group was deleted"
            menu_action    = "test-actions 4730"
        }

### 3.  How can I add my own custom fields to the EventID that is already in the menu system?
In the_test-actions()_ function there is a switch environmment that allows you to add commands to any EventID you want or to groups of eventID's.  Here are some examples fromthe script:

##### - Replace the contents of _test-target-user-name_ field with "Administrator"
```
        "4624" { 
           $key_items = $key_items -replace "test-target-user-name","administrator"
        }        

```
##### - Add a bunch of other fields and their data to the log line for event 4723 (NOTE:  Lack of comma on last item!)
```
        "4625" { 
           $key_items += " ,winlog_host_name                  = your_HOST_name,
                            winlog_event_data_LogonType       = 11,
                            winlog_event_data_SubStatus       = 0xC0000225,
                            winlog_event_SubjectDomainName    = your_DOMAIN,
                            winlog_event_data_WorkstationName = your_WORKSTATION
                         "
        }        
```
##### - Add a bunch of fields to any of these EventID's(NOTE:  Lack of comma on last item!)
```
        "^(4734|4730|4758|4748|4753|4763)$" { 
           $key_items += " ,my_favorite_field                 = dreams,
                            winlog_event_data_LogonType       = 11,
                            winlog_event_data_SubStatus       = 0xC0000225,
                            winlog_event_SubjectDomainName    = your_DOMAIN,
                            winlog_event_data_WorkstationName = your_WORKSTATION
                         "
        }        
```

### 5.  How do I send a bunch of EventID's at once?
I didn't program that ability in.  But feel free to copy/paste a bunch of already sent lines int he logfile back into the log file so that the system picks them all up at once.


