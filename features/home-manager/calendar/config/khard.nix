{ config, contactsUuid, ... }: ''
[addressbooks]
[[personal]]
path = ~/${config.xdg.dataHome}/contacts/${contactsUuid}/

[general]
debug = no
default_action = list
editor = nvim, -i, NONE
merge_editor = nvim, -d

[contact table]
display = first_name
group_by_addressbook = no
reverse = no
show_nicknames = yes
show_uids = no
sort = last_name
localize_dates = yes
preferred_phone_number_type = pref, cell, home
preferred_email_address_type = pref, home, work

[vcard]
private_objects = Jabber,
preferred_version = 3.0
search_in_source_files = no
skip_unparsable = no
''