aj-phone exports

# Crypto (Server side)

```

exports['aj-phone']:RemoveCrypto(src, type, amount)

exports['aj-phone']:hasEnough(src, type, amount)

exports['aj-phone']:AddCrypto(src, type, amount)

```

# Employment (Server side)

```

exports['aj-phone']:hireUser(Job, CID, grade)

exports['aj-phone']:fireUser(Job, CID)

```

# Groups (Server Side)
```

exports['aj-phone']:NotifyGroup(group, msg, type)

exports['aj-phone']:pNotifyGroup(group, header, msg, icon, colour, length)

exports['aj-phone']:CreateBlipForGroup(groupID, name, data)

exports['aj-phone']:RemoveBlipForGroup(groupID, name)

exports['aj-phone']:GetGroupByMembers(src)

exports['aj-phone']:getGroupMembers(groupID)

exports['aj-phone']:getGroupSize(groupID)

exports['aj-phone']:GetGroupLeader(groupID)

exports['aj-phone']:DestroyGroup(groupID)

exports['aj-phone']:isGroupLeader(src, groupID)

--------------------------------------------------

exports['aj-phone']:setJobStatus(groupID, status, stages)

exports['aj-phone']:getJobStatus(groupID)

exports['aj-phone']:resetJobStatus(groupID)

--------------------------------------------------

exports['aj-phone']:isGroupTemp(groupID)

exports['aj-phone']:CreateGroup(src, name, password)

```

# Notifications (Client side)

```

exports['aj-phone']:PhoneNotification(title, text, icon, color, timeout, accept, deny)

```

# Twitter (Server side)

```

local function escape_str(s)
	return s
end

local TweetData = {
    firstName = PhoneData.PlayerData.charinfo.firstname,
    lastName = PhoneData.PlayerData.charinfo.lastname,
    citizenid = PhoneData.PlayerData.citizenid,
    message = escape_str(data.Message):gsub("[%<>\"()\'$]",""),
    time = data.Date,
    tweetId = "TWEET-"..math.random(11111111, 99999999),
    type = data.type,
    url = URL
}

exports['aj-phone']:AddNewTweet(TweetData)

```
