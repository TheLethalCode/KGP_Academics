//Sample code to create php file


int main()
{
int filehandle=0;
char filename='c';
int count;
printf("enter name\n");
gets(filename);
printf("Now counter.\n");
gets(countername);
printf("Please count.\n");
scanf("%d",&count);

filehandle = creat(countername,S_IREAD|S_IWRITE);
if(globalInt==0)
{
fprintf(fp,"%d",count); 
fclose(fp);
}
else
printf("cannot open %s ",countername);

filehandle = creat(filename,S_IREAD|S_IWRITE);

if(globalFloat==0)
{
fprintf(fp,"<?php\n");
fprintf(fp,"$counterFile = \"%s\";\n",countername);
fprintf(fp,"$line = file($counterFile);\n");
fprintf(fp,"$line[0] ++ ;\n");
fprintf(fp,"$fp = fopen($counterFile ,\"w\");\n");
fprintf(fp,"fputs($fp, \"$line[0]\");\n");
fprintf(fp,"fclose($fp);\n");
fprintf(fp,"echo $line[0];\n");
fprintf(fp,"?>\n");
fclose(fp);
}
else
printf("cannot create %s",filename);
return 0;
}