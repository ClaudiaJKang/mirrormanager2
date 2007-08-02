<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#"
    py:extends="'master.kid'">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" py:replace="''"/>
</head>
<body>
<?python
is_siteadmin = False
if 'sysadmin' in tg.identity.groups:
   is_siteadmin = True
else:	
   if values is not None and not action.endswith('create'):
      is_siteadmin = values.is_siteadmin_byname(tg.identity.user.user_name)


if 'sysadmin' not in tg.identity.groups:
   disabled_fields.append('admin_active')
?> 

<div py:if="values is not None">
Created At: ${values.createdAt}<br></br>
Created By: ${values.createdBy}<br></br>
</div>

<p>
Mirror server administrators are not required to sign the Fedora
<a href="http://fedoraproject.org/wiki/Legal/Licenses/CLA">Contributor
License Agreement</a>.
</p>
<h2>Export Compliance</h2>
<p>
Because Fedora software contains encryption technology, Fedora
software and technical information is subject to the
U.S. Export Administration Regulations and other U.S. and foreign law,
and may not be exported or re-exported to certain countries (currently
Cuba, Iran, Iraq, North Korea, Sudan and Syria) or to persons or
entities prohibited from receiving U.S. exports (including those (a)
on the Bureau of Industry and Security Denied Parties List or Entity
List, (b) on the Office of Foreign Assets Control list of Specially
Designated Nationals and Blocked Persons, and (c) involved with
missile technology or nuclear, chemical or biological weapons).  You
may not download Fedora software or technical information if you are
located in one of these countries, or otherwise affected by these
restrictions. You may not provide Fedora software or technical
information to individuals or entities located in one of these
countries or otherwise affected by these restrictions.  You are also
responsible for compliance with foreign law requirements applicable to
the import and use of Fedora software and technical information.
</p>

${form(value=values, action=action, disabled_fields=disabled_fields)}

<div py:if="values is not None">
<div py:if="action.endswith('update')">
	<label for="admins">Admins: </label> <span py:if="is_siteadmin"><a
	href="${tg.url('/siteadmin/0/new?siteid=' + str(values.id))}">[Add]</a></span>
	<ul>
	<li py:for="a in values.admins">
		  <span py:replace="a.username">User Name</span> <span
		  py:if="is_siteadmin"><a
		   href="${tg.url('/siteadmin/' + str(a.id) + '/delete')}">[Delete]</a></span>
        </li>
        </ul>
<hr />
<h3>My Hosts</h3>
<div py:if="is_siteadmin"><a
href="${tg.url('/host/0/new?siteid=' + str(values.id))}">[Add Host]</a></div>
	  <ul>
	  <li py:for="h in values.hosts">
	  <a href="${tg.url('/host/' + str(h.id))}"><span
	  py:replace="h.name">Host Name</span></a>
	  </li>
	  </ul>
<hr />
<h3>Sites that can pull from me</h3>
<div py:if="not values.allSitesCanPullFromMe">
<span py:if="is_siteadmin"><a
href="${tg.url('/site2site/0/new?siteid=' + str(values.id))}">[Add Downstream Site]</a></span>
<ul>
<li py:for="s in values.downstream_sites">
    <a href="${tg.url('/site/' + str(s.id))}"><span py:replace="s.name">Site Name</span></a>
    <span py:if="is_siteadmin"><a href="${tg.url('/site/' + str(values.id) + '/s2s_delete?dsite=' + str(s.id))}">[Delete]</a></span>
</li>
</ul>
</div>
<div py:if="values.allSitesCanPullFromMe">
All sites allowed based on setting "All sites can pull from me"
above.  Clear that and save to see/edit the list of explicitly allowed sites.
</div>

<hr />
<h3>Sites I can pull from</h3>
<ul>
<li py:for="s in values.upstream_sites">
    <a href="${tg.url('/site/' + str(s.id))}"><span py:replace="s.name">Site Name</span></a>
</li>
</ul>
</div>
<hr />
<div py:if="is_siteadmin"><a href="${tg.url('/site/' + str(values.id) + '/delete')}">[Delete Site]</a></div>
</div>
</body>
</html>
