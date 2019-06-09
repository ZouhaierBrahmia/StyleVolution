<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{ for $ct in //xsd:complexType
  let $type := concat($ct/../@name,'Type')
  return
  <xsd:complexType name="{$type}">
    <xsd:sequence>
    { for $el in $ct/xsd:sequence/xsd:element
      return
        <xsd:element ref="{$el/@name}">
        { for $ea in $el/@*
          where name($ea)!="name" and name($ea)!="type"
          return $ea
        }
        </xsd:element>
    }
    </xsd:sequence>
    { for $a in $ct/xsd:attribute
      return
        <xsd:attribute ref="{$a/@name}"> 
        { for $aa in $a/@*
          where name($aa)!="name" and name($aa)!="type"
          return $aa
        }
        </xsd:attribute>
    }
  </xsd:complexType>
}

{ for $st in //xsd:simpleType
  let $type := concat($st/../@name,'Type')
  let $def := $st/*
  return
    <xsd:simpleType name="{$type}">
      {$def}
    </xsd:simpleType>
}

{ for $el in //xsd:element[xsd:complexType or xsd:simpleType]
  let $type := concat($el/@name,'Type')
  return <xsd:element name="{$el/@name}" type="{$type}"/>
}

{ for $at in //xsd:attribute[xsd:simpleType]
  let $type := concat($at/@name,'Type')
  return <xsd:attribute name="{$at/@name}" type="{$type}"/>
}

{ for $el in //xsd:element[not(*)]
  return $el
}

{ for $at in //xsd:attribute[not(*)]
  return $at
}

</xsd:schema>