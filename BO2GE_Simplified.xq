<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{ for $ct in //xsd:complexType[xsd:sequence]
  let $type := if ($ct[@name]) 
               then $ct/@name else concat($ct/../@name,'Type')
  return
  <xsd:complexType name="{$type}">
    <xsd:sequence>
    { for $el in $ct/xsd:sequence/xsd:element
      return
        if ($el[@ref]) 
        then $el
        else <xsd:element ref="{$el/@name}">
        { for $ea in $el/@*
          where name($ea)!="name" and name($ea)!="type"
          return $ea
        }
        </xsd:element>
    }
    </xsd:sequence>
    { for $a in $ct/xsd:attribute
      return
        if ($a[@ref])
        then $a
        else <xsd:attribute ref="{$a/@name}"> 
        { for $aa in $a/@*
          where name($aa)!="name" and name($aa)!="type"
          return $aa
        }
        </xsd:attribute>
    }
  </xsd:complexType>
}

{ for $st in //xsd:simpleType
  let $name := if ($st[@name]) 
               then $st/@name else concat($st/../@name,'Type')
  let $def := $st/*
  return
    <xsd:simpleType name="{$name}">
      {$def}
    </xsd:simpleType>
}

{ for $el in //xsd:element[xsd:complexType or xsd:simpleType or @type]
  let $type := if ($el[@name and not(@type)]) 
               then concat($el/@name,'Type') else $el/@type
  return <xsd:element name="{$el/@name}" type="{$type}"/>
}

{ for $at in //xsd:attribute[xsd:simpleType or @type]
  let $type := if ($at[@name and not(@type)]) 
               then concat($at/@name,'Type') else $at/@type
  return <xsd:attribute name="{$at/@name}" type="{$type}"/>
}

</xsd:schema>