function [split,numpieces]=explode_without_spaces(string,delimiters)
%EXPLODE    Splits string into pieces.
%   EXPLODE(STRING,DELIMITERS) returns a cell array with the pieces
%   of STRING found between any of the characters in DELIMITERS.
%
%   [SPLIT,NUMPIECES] = EXPLODE(STRING,DELIMITERS) also returns the
%   number of pieces found in STRING.
%
%This without spaces version trimms the spaces and similar characters (the ones trimmed by strtok) inside each cell
%   Input arguments:
%      STRING - the string to split (string)
%      DELIMITERS - the delimiter characters (string)
%   Output arguments:
%      SPLIT - the split string (cell array), each piece is a piece
%      NUMPIECES - the number of pieces found (integer)
%
%   Example:
%      STRING = 'ab_c,d,e fgh'
%      DELIMITERS = '_,'
%      [SPLIT,NUMPIECES] = EXPLODE(STRING,DELIMITERS)
%      SPLIT = 'ab'    'c'    'd'    'e fgh'
%      NUMPIECES = 4
%
%   See also STRTOK
%
%   Created "explode" : Sara Silva (sara@itqb.unl.pt) - 2002.04.30
%   Updated from "explode": Rodrigo Gouveia-Oliveira(rodrigo@itqb.unl.pt) - 2002.11.01

if isempty(string) % empty string, return empty and 0 pieces
   split{1}='';
   numpieces=0;
   
elseif isempty(delimiters) % no delimiters, return whole string in 1 piece
   split{1}=string;
   numpieces=1;
   
else % non-empty string and delimiters, the correct case
   
   remainder=string;
   i=0;
   
	while ~isempty(remainder)
   	[piece,remainder]=strtok(remainder,delimiters);
   	i=i+1;
    piece3=[];
        while ~isempty(piece) 
            [piece2,piece]=strtok(piece);
            piece3=[piece3 piece2];
        end
        split{i}=piece3;
    end
   numpieces=i;
   
end
