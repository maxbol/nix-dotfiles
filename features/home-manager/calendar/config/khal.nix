{ config, contactsUuid, ... }: ''
[calendars]

[[calendar_local]]
path = ~/${config.xdg.dataHome}/calendar/*
type = discover

[[contacts_local]]
path = ~/${config.xdg.dataHome}/contacts/${contactsUuid}/
type = birthdays

[locale]
timeformat = %H:%M
dateformat = %Y-%m-%d
longdateformat = %Y-%m-%d
datetimeformat = %Y-%m-%d %H:%M
longdatetimeformat = %Y-%m-%d %H:%M
''