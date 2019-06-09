<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{ for $el in /xsd:schema/xsd:element
  return $el
}

{ for $ct in /xsd:schema/xsd:complexType
  return
  <xsd:complexType name="{$ct/@name}">
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

{ for $ct in /xsd:schema/xsd:complexType
    for $el in $ct/xsd:sequence/xsd:element
    return
      <xsd:element name="{$el/@name}" type="{$el/@type}" />
}

{ for $ct in /xsd:schema/xsd:complexType
    for $a in $ct/xsd:attribute
    return
      <xsd:attribute name="{$a/@name}" type="{$a/@type}"/>
}

{ for $st in /xsd:schema/xsd:simpleType
  return $st
}

</xsd:schema>