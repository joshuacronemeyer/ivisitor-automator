INPUT='rsvps.txt'
OUTPUT='automated_name_entry.html'
COMPANY='Clojure'

preamble = <<eos
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head profile="http://selenium-ide.openqa.org/profiles/test-case">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="selenium.base" href="" />
<title>automated_checkin</title>
</head>
<body>
<table cellpadding="1" cellspacing="1" border="1">
<thead>
<tr><td rowspan="1" colspan="3">automated_checkin</td></tr>
</thead><tbody>
<tr>
  <td>open</td>
  <td>/ivisitor/DashBoard</td>
  <td></td>
</tr>
<tr>
  <td>click</td>
  <td>5</td>
  <td></td>
</tr>
<tr>
  <td>selectFrame</td>
  <td>CONTENT</td>
  <td></td>
</tr>
eos

postamble = <<eos
</tbody></table>
</body>
</html>
eos

def first_entry(first, last, script)
  return <<eos
<tr>
  <td>type</td>
  <td>firstName</td>
  <td>#{first}</td>
</tr>
<tr>
  <td>type</td>
  <td>lastName</td>
  <td>#{last}</td>
</tr>
<tr>
  <td>type</td>
  <td>companyName</td>
  <td>#{COMPANY}</td>
</tr>
<tr>
  <td>select</td>
  <td>visiting</td>
  <td>label=Cronemeyer, Joshua</td>
</tr>
<tr>
  <td>click</td>
  <td>emailhost</td>
  <td></td>
</tr>
<tr>
  <td>type</td>
  <td>purpose</td>
  <td>#{COMPANY}</td>
</tr>
<tr>
  <td>type</td>
  <td>destination</td>
  <td>25th</td>
</tr>
<tr>
  <td>select</td>
  <td>startVisit</td>
  <td>label=6:00 PM</td>
</tr>
<tr>
  <td>select</td>
  <td>endVisit</td>
  <td>label=8:00 PM</td>
</tr>
<tr>
  <td>clickAndWait</td>
  <td>more_in_group</td>
  <td></td>
</tr>
eos
end

def type_it(field, value, script)
  script << "<tr>\n"
  script << "<td>type</td>\n"
  script << "<td>#{field}</td>\n"
  script << "<td>#{value}</td>\n"
  script << "</tr>\n"
end

def first_name(line)
  return line.split(" ")[0]
end

def last_name(line)
  first_last = line.split(" ")
  return first_last.size > 1 ? first_last[1] : "Unknown"
end

rsvps = IO.readlines(INPUT)
puts "Writing #{OUTPUT} with #{rsvps.size} rsvps"
script = []
script << preamble

script << first_entry(first_name(rsvps.first), last_name(rsvps.first), script)
rsvps.delete_at(0)

rsvps.each_with_index do |rsvp, index|
  first = first_name(rsvp)
  last = last_name(rsvp)
  count = index%10 + 1
  if count == 1 && index != 0
    script << "<tr>\n"
	  script << "<td>clickAndWait</td>\n"
	  script << "<td>More</td>\n"
	  script << "<td></td>\n"
    script << "</tr>\n"
  end
  type_it("first#{count}", first, script)
  type_it("last#{count}", last, script)
  type_it("company#{count}", COMPANY, script)
end
script << "<tr>\n"
script << "<td>clickAndWait</td>\n"
script << "<td>Save</td>\n"
script << "<td></td>\n"
script << "</tr>\n"

script << postamble

File.open(OUTPUT, 'w'){|f| f.write(script)}
