function myrptpop(doctype, subject_ID)
%RPTPOP DOM-based report example
%
%   This example is based on the MATLAB example: "Predicting the US
%   Population." That example was generated using MATLAB Publish. This
%   example is generated using the DOM API. This example is intended to
%   illustrate a simple use of the API, one that does not entail use of
%   holes or templates.
%
%   rptpop() generates an HTML version of the report.
% 
%   rptpop(doctype) generates a report of the specified type:
%   'html', 'docx', or 'pdf'.
% patientID - float

%   Copyright MathWorks, 2013-2014.

% This statement eliminates the need to qualify the names of DOM
% objects in this function, e.g., you can refer to 
% mlreportgen.dom.Document simply as Document.
import mlreportgen.dom.*;


if nargin < 2
    doctype = 'docx';
end

% Create a cell array to hold images that we are going to generate
% for this report. That will facilitate deleting the images at the
% end of report generation when they are no longer needed.
images = {};
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', 'Kasia_P',...
    'Monika_W','Teresa_B','Ula_M','Urszula_O', 'Jedrzej_R'...
    'Klaudia_W'};
comments = {'musical school (oboe)','-', '-','-','-',...
    'OAE measurements on evening', 'musical school - percussion','-', '-','-',...
    'no SFOAE', 'external noises during OAE measurements', '-','-','-',...
    '-','-','-','-','previous problems with ears','bad impedance audiometry - no reflexes'};
% Create a document.
doc = Document(['Subject ' num2str(subject_ID) ' summary'], doctype);
open(doc);
s = doc.CurrentDOCXSection;
s.PageMargins.Left  = '.5in';
s.PageMargins.Right = '.5in';
s.PageMargins.Top = '.5in';
s.PageMargins.Bottom = '.5in';

% Create a title for the report.
h = Heading(2, ['Summary subject ID: ' num2str(subject_ID)]);

% Create a border format object that effectively draws a light gray
% rule under the title.
b = Border();
b.BottomStyle = 'single';
b.BottomColor = 'LightGray';
b.BottomWidth = '1pt';

% Set the style of the title programmatically to be dark orange with 
% a light gray rule under it.
%
% Note that we could have achieved the same effect
% by defining a title style in a template associated with this object
% and setting the heading's StyleName property to the name of the 
% template-defined style, e.g.,
%
% h.StyleName = 'Title';
%
% This would allow us to change the appearance of the title without 
% having to change the code.
%
% Note also that we append the border and color format objects to the
% heading's existing Style array. This avoids overwriting the
% heading's existing OutlineLevel format.
h.Style = [h.Style {Color('DarkOrange'), b}];

% Append the heading to the document.
append(doc, h);

% Add some boilerplate text to the document, using the addBodyPara
% function defined below. Note that we could have included this text
% in a template created especially for this report. That would simplify
% this function significantly and allow us to modify the boilerplate
% text without having to modify this code.
addBodyPara(doc, 'Summary of short (quick) and long (cluster) SFOAE, DPOAE and audiogram');

% Plot
name_idx = subject_ID;
name = char(names(name_idx));
fname = 'audiograms20bezemnieiKlaudii.mat';

analysis_audiogram(name, name_idx,fname);


% Add the plot to the document (see addPlot function below).
img = addPlot(doc, 'plot1');

% Add plot image to the list of images to be deleted at the end of
% report generation. Note that we need to keep the images around until
% the report is closed. That is because we cannot add images to the
% report package while the main report file is still open.
images = [images {img}]; %#ok<*NASGU>

%%% add plot for SOAE!


% Add some more boilerplate to the report.
addBodyPara(doc, 'Audiograms for both ears, dashed lines are 1st and 3rd population quantiles for this ear');

directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];

for ear = {'L', 'R'}
filename = ['SOAE ' name ' ' char(ear) '.png'];
A = imread([directory_name filename]);
image(A);
rptgen.cfr_image(doc,[directory_name filename]);
img = addPlot(doc, ['plotSOAE_' char(ear)]);
images = [images {img}]; 

end
snr_value = 9; sndiff = 6; CreatePool = 0;
PopulationMeansFileName = 'srednie20osob_all.mat';
[fr,R2,  m_SFs] = analysis_short(name, name_idx,snr_value,0, 0,0,PopulationMeansFileName); %fraction of passes in %    
img = addPlot(doc, 'plot2');
images = [images {img}]; %#ok<*NASGU>

% Add more boilerplate.
addBodyPara(doc, 'SFOAE, grey area shows 1st and 3rd quantile of means from all subjects having DPOAE (with subject 11, without this having problems with impedance audiometry and without me');
    option = 'all'; % options: 'clean', 'max_snr', 'all'
    [fr,R2, m_SFL] = analysis_long(name, name_idx,snr_value,0, option, 0, PopulationMeansFileName); %fraction of passes in 
img = addPlot(doc, 'plot3');
images = [images {img}]; %#ok<*NASGU>
addBodyPara(doc, '"all" means that all 5 points in a cluster were taken to calculations of average for this frequency (for single red or green circle)');
% DPOAE
    [fr,R2, m_DP] = analysis_dpoae(name, name_idx,sndiff,0, 0, PopulationMeansFileName); %fraction of passes in 
img = addPlot(doc, 'plot4');
images = [images {img}]; %#ok<*NASGU>
% addBodyPara(doc, 'DPOAE');

% c = A(:,n-3:n)\p;

% Append array of coefficients to the report. Note that we can append
% numeric (and cell) arrays directly to the document. The DOM API 
% converts a 1xN array to a list and an MxN array to a table. (Arrays
% of more than two dimensions are not supported).
% append(doc, c);

% v = (1900:2020)';
% x = (v-1950)/50;
% w = (2010-1950)/50;
% y = polyval(c,x);
% z = polyval(c,w);

% hold on
% plot(v,y,'k-');
% plot(2010,z,'ks');
% text(2010,z+15,num2str(z));
% hold off

% img = addPlot(doc, 'plot2');
% images = [images {img}]; %#ok<*NASGU>
% 
% addBodyPara(doc, 'Compare the cubic fit with the quartic.  Notice that the extrapolated point is very different.');
% 
% c = A(:,n-4:n)\p;
% y = polyval(c,x);
% z = polyval(c,w);
% 
% hold on
% plot(v,y,'k-');
% plot(2010,z,'ks');
% text(2010,z-15,num2str(z));
% hold off
% 
% img = addPlot(doc, 'plot3');
% images = [images {img}]; %#ok<*NASGU>

addBodyPara(doc, ['Comment: ' char(comments(subject_ID))]);

cla
% plot(t,p,'bo'); hold on; axis([1900 2020 0 400]);
% colors = hsv(8); labels = {'data'};
% for d = 1:8
%    [Q,R] = qr(A(:,n-d:n));
%    R = R(1:d+1,:); Q = Q(:,1:d+1);
%    c = R\(Q'*p);    % Same as c = A(:,n-d:n)\p;
%    y = polyval(c,x);
%    z = polyval(c,11);
%    plot(v,y,'color',colors(d,:));
%    labels{end+1} = ['degree = ' int2str(d)]; %#ok<AGROW>
% end
% legend(labels,2)
% 
% img = addPlot(doc, 'plot4');
% images = [images {img}]; %#ok<*NASGU>

% Close the report.
close(doc);

% Closing the report causes the images needed for the report to be copied
% into the report package (docx for Word, htmx for HTML). So we can
% now delete them.
for i = 1:length(images)
    delete(images{i});
end

% rptview('population', doctype);

end

function addBodyPara(doc, text)
% Format report text and append it to a document.
import mlreportgen.dom.*;
p = append(doc, Paragraph(text));
p.Style = {FontFamily('Arial'), FontSize('10pt')};
end

function imgname = addPlot(doc, name)
% Convert the specified plot to an image and
% append the image to the document. Return
% the image name so it can be deleted at the
% end of report generation.
import mlreportgen.dom.*;

% Select an appropriate image type, depending
% on the document type.
if strcmpi(doc.Type, 'html')
    imgtype = '-dpng';
    imgname= [name '.png'];
else
    % This Microsoft-specific vector graphics format
    % can yield better quality images in Word documents.
    imgtype = '-dmeta';
    imgname = [name '.emf'];
end

% Convert figure to the specified image type.
print(imgtype, imgname);

% Set image height and width.
img = Image(imgname);
img.Width = '6.5in';
img.Height = '4in';

% Append image to document.
append(doc, Paragraph(img));

% Delete plot figure window.
delete(gcf);

end



