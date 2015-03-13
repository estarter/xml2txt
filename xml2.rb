#!/c/Ruby187/bin/ruby -w
require 'rexml/document'
include REXML

# script converts xml to flatten txt format

if ARGV.size != 1
  puts "usage: ruby xml2.rb xml_file"
  exit 0
end

class String
  NON_WHITESPACE_REGEXP = %r![^\s#{[0x3000].pack("U")}]!

  def blank?
    self !~ NON_WHITESPACE_REGEXP
  end
end

class REXML::Element
  def full_name
    result = path
    if self.has_attributes?
        result += "["
        result += self.attributes.map{|k,v| "#{k}=#{v}"}.join(",")
        result += "]"
    end
    return result
  end
  def full_path
    path = [self.full_name]
    p = parent
    while p.class != REXML::Document
      path.unshift p.full_name
      p = p.parent
    end
    path.compact.join("/")
  end
  def path
    if name == "Attribute"
      return "Attribute[#{elements["AttributeName"].text}]"
    elsif name == "AttributeName"
      return nil
    elsif name == "AttributeFamily"
      return "AttributeFamily[#{elements["AttributeFamilyName"].text}]"
    elsif name == "AttributeFamily"
      return nil
    else
      str = name
      if has_text? && !text.blank?
        str += "=#{text.gsub(/\n/, '\\n')}"
      end
      return str
    end
  end
end

def process(elem)
  if elem.has_elements?
    elem.each_element{|e| process(e)}
  else
    puts elem.full_path
  end
end

xmldoc = Document.new(File.new(ARGV[0]))
root = xmldoc.children.reject{|e| e.class != REXML::Element}[0]
root.each_element{|e| process(e) }
