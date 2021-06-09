clear; clc;

% IO for xml files

cmcfolder = "ComputedMuscleControl/";
%type(XMLfile);

XMLfile = "samplexml.xml";
%mlStruct = parseXML(XMLfile);

s = xml2struct(XMLfile);
h = xml2struct(cmcfolder+"cmc_setup.xml");


% edit xml file properties as you see fit


xmlfile = cmcfolder+"setup_test.xml";
struct2xml(h, xmlfile);



