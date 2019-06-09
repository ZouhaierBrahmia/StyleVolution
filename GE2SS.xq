<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{ for $el in /xsd:schema/xsd:element[@name]
  let $name := $el/@name
  let $type := $el/@type
  let $el1 := /xsd:schema/*[@name=$type]
  return 
  if ($el1)
  then
  <xsd:element name="{$name}">
  { element {$el1/name()}
    { $el1/* }
  }
  </xsd:element>
  else $el
}

{ for $at in /xsd:schema/xsd:attribute[@name]
  let $name := $at/@name
  let $type := $at/@type
  let $at1 := /xsd:schema/*[@name=$type]
  return
  if ($at1)
  then
  <xsd:attribute name="{$name}">
  { element {$at1/name()}
    { $at1/* }
  }
  </xsd:attribute>
  else $at
}

</xsd:schema>