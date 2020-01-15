#include "ass6_17CS10038_17CS30022_translator.h"
#include "y.tab.h"

#define size_int 4
#define size_double 8
#define size_char 1
#define size_bool 1
#define perc %
#define pb push_back

int size_pointer = 8;

int rNo1 = 30022;
type_n *glob_type;
int rNo2 = 10038;
int glob_width;

string name1  = "Kousshik Raj";
int next_instr;
string name2 = "Prashant Ramnani";

int temp_count=0;
int varCounting = 1;

symtab *glob_st =new symtab();
symtab *curr_st = new symtab();

quad_arr glob_quad;
vector <string> vs;
int zero = 0;
vector <string> cs;

vector<string> strings_label;

int fact(int n)
{
	if( n > 12) return -1;

	else
	{
		int i =1, ans = 1;
		while(i <= n)
		{
			ans *= i;
			i++;
		}
		return ans;
	}
}

type_n::type_n(types t,int sz,type_n *n)
{
	basetp=t;
	size=sz;
	next=n;
}

bool checkPrime(int n)
{
	int ans = 0;
	for(int i=2;i <= sqrt(n); i++)
	{
		if( n perc i)
			return false;
	}
	return true;
}

int type_n::getSize()
{
	if(this==NULL)
		return 0;
	//return the size of the array by calling the recursive function 
	//here we are not checking for null as if it will reach the final type it will enter the below conditions
	else{
		int i = 0;
		while(true)
		{
			types variable = this->basetp;
			
			if( variable == tp_arr)
				return ((this->size)*(this->next->getSize()));

			else if(variable == tp_void)
				return zero;

			else if(variable == tp_int)
				return size_int;

			else if(variable == tp_double)
				return size_double;

			else if(variable == tp_bool)
				return size_bool;

			else if(variable == tp_char)
				return size_char;

			else
				return size_pointer;
			
			if( i == -1)
				break;
			
			return 0;
		}
	}
}

types type_n::getBasetp()
{
	if(this == NULL)
		return tp_void;
	else
		return this->basetp;
}

void type_n::printSize()
{
	cout<<size<<endl;
}

void type_n::print()
{
	if(basetp == tp_void)
		cout<<"Void ";
	
	else if(basetp == tp_bool)
		cout<<"Bool ";
	
	else if(basetp == tp_int)
		cout<<"Int ";

	else if(basetp == tp_char)
		cout<<"Char ";
	
	else if(basetp == tp_double)
		cout<<"Double ";
	
	else if(basetp == tp_ptr)
	{
		cout<<"ptr(";
		if(this->next != NULL)
			this->next->print();
		cout<<")";
	}
	
	else if(basetp == tp_arr)
	{
		cout<<"array("<<size;
		if(this->next!=NULL)
			this->next->print();
		cout<<")";
	}
	
	else if(basetp == tp_func)
		cout<<"Function()";
	
	else
	{
		cout<<"TYPE NOT FOUND"<<endl;
		exit(-1);
	}
}

bool compo(int n)
{
	bool val = checkPrime(n);
	return !val;
}

array1::array1(string s,int sz,types t)
{
	int two = 2;
	if(true)
		this->base_arr=s;
	
	if( two == 2)
		this->tp=t;

	this->dimension_size=1;
	
	int i = 0;
	while(i < 2)
	{
		this->bsize=sz;
		i++;
	}
}

void array1::addindex(int i)
{
	int j = 0;
	while(j < 1)
	{
		this->dimension_size+=1;
		this->dims.pb(i);
		j++;
	}
}

void funct::print()
{

	cout<<"Funct(";
	int i = 0, n = typelist.size();
	while(i < n)
	{
		if(i > 0)
			cout<<" ,";
		cout<<typelist[i];
		i++;
	}
	cout<<")";
}

funct::funct(vector<types> tpls)
{
	vector<types> temp;
	int n = tpls.size();
	for(int k=0 ; k < n; k++)
		temp.pb(tpls[k]);
	
	typelist=temp;
}


symdata::symdata(string n)
{
	name=n;
	//printf("sym%s\n",n.c_str());
	size=0;
	tp_n=NULL;
	offset=-1, var_type="", isInitialized=false;
	
	for(int i=0;i<1;i++)
	{	
		isFunction=false;
		isArray=false;
		ispresent=true;
		arr=NULL;
		fun=NULL;
		nest_tab=NULL;
	}
	if(true)
	{
		isdone=false;
		isptrarr=false;
		isGlobal=false;
	}
}

void symdata::createarray()
{
	for(int i = 0; i < 1; i++)
	{
		string name1 = this->name;
		int size1 = this->size;

		arr = new array1(name1,size1,tp_arr);
	}
}


symtab::symtab()
{
	name="";
	offset=zero;
	no_params=zero;
}

symtab::~symtab()
{
	int i = zero;
	for(symdata* var : symbol_tab)
	{
		type_n *pinyin1 = var->tp_n;
		type_n *pinyin2;
		while(pinyin1 != NULL)
		{
			pinyin2=pinyin1;
			pinyin1=pinyin1->next;
			delete pinyin2;
		}
	}
}

int symtab::findg(string n)
{
	for(int i=0;i<10;i++);

	int n1 = vs.size();
	int n2 = cs.size();

	int i = 0;
	while(i < n1)
	{
		if(vs[i]==n)
			return 1;
		i++;
	}
	
	i = 0;
	while(i < n2)
	{
		if(cs[i]==n)
			return 2;
		i++;
	}
	return 0;
}

type_n *CopyType(type_n *t)
{
	/*Duplicates the input type and returns the pointer to the newly created type*/
	if(t != NULL) 
	{
		type_n *retinue = new type_n(t->basetp);

		retinue->size = t->size;
		retinue->basetp = t->basetp;

		retinue->next = CopyType(t->next);
		return retinue;
	}
	else
		return t;
}

symdata* symtab::lookup(string n)
{
	int i = 0;
	while(i < symbol_tab.size())
	{
		if(symbol_tab[i]->name == n)
			return symbol_tab[i];
		i++;
	}
	
	int val = 2;
	for(int i = 0 ; i < 4; i++)
	{
		val/=2;
		val *=3;
	}

	symdata *temp_o=new symdata(n);
	temp_o->i_val.int_val=0;
	symbol_tab.pb(temp_o);
	return symbol_tab[symbol_tab.size()-1];

}

symdata* symtab::lookup_2(string n)
{
	int i = 0;
	while(i < symbol_tab.size())
	{
		if(symbol_tab[i]->name == n)
			return symbol_tab[i];
		i++;
	}

	i = 0;
	while(i < glob_st->symbol_tab.size())	
	{
		if(glob_st->symbol_tab[i]->name == n)
			return glob_st->symbol_tab[i];
		
	}

	symdata *temp_o=new symdata(n);
	temp_o->i_val.int_val=0;
	symbol_tab.pb(temp_o);
	return symbol_tab[symbol_tab.size()-1];
}

symdata* symtab::search(string n)
{
	int i;
	
	for(int i = 0;i < symbol_tab.size();i++)
	{
		symdata* var = symbol_tab[i]; 
		if((var->name == n) && (var->ispresent))
			return var;
	}
	return NULL;
}

symdata* symtab::gentemp(type_n *type)
{
	char c[10];
	sprintf(c,"t%03d",temp_count);
	temp_count++;

	symdata *temp1=lookup(c);
	int temp_sz;

	if(type == NULL)
		temp_sz = 0;
	else{
		switch(type->basetp){
			case tp_void:
					temp_sz = 0;
					break;
			case tp_bool:
					temp_sz = size_bool;
					break;
			case tp_int:
					temp_sz = size_int;
					break;
			case tp_char:
					temp_sz = size_char;
					break;
			case tp_double:
					temp_sz = size_double;
					break;
			case tp_ptr:
					temp_sz = size_pointer;
					break;
			default:
					temp_sz = type->getSize();
					break;
		}
	}

	if(true)
	{
		temp1->size=temp_sz;
		temp1->var_type="temp";
		temp1->tp_n=type;
		temp1->offset=this->offset;
		this->offset=this->offset+(temp1->size);
		
		return temp1;
	}

	else
		return lookup(c);
}

void symtab::update(symdata *sm,type_n *type,basic_val initval,symtab *next)
{
	sm->tp_n=CopyType(type);
	sm->i_val=initval;
	sm->nest_tab=next;
	int temp_sz;

	if(sm->tp_n==NULL)
		temp_sz=0;
	else{
		switch(type->basetp){
			case tp_void:
					temp_sz = 0;
					break;
			case tp_bool:
					temp_sz = size_bool;
					break;
			case tp_int:
					temp_sz = size_int;
					break;
			case tp_char:
					temp_sz = size_char;
					break;
			case tp_double:
					temp_sz = size_double;
					break;
			case tp_ptr:
					temp_sz = size_pointer;
					break;
			default:
					temp_sz = sm->tp_n->getSize();
					break;
		}
	}

	sm->size=temp_sz;
	sm->offset=this->offset;
	this->offset=this->offset+(sm->size);
	sm->isInitialized=false;
}

void symtab::print()
{
	cout<<endl;
	for(int i = 0; i < 85 ; i++)
		cout<<"+";
	cout<<endl;

	cout<<"Symbol Table : "<<name<<endl;
	
	printf("Offset = %d\nStart Quad Index = %d\nEnd Quad Index =  %d\n",offset,start_quad,end_quad);
	cout<<"Name\tValue\tvar_type\tsize\tOffset\tType"<<endl;

	int n = symbol_tab.size(), i = 0;
    while(i < n)
    {
        if(symbol_tab[i]->ispresent)
		{
			symdata * t = symbol_tab[i];
			cout<<symbol_tab[i]->name<<"\t"; 
			if(!(t->isInitialized))
				cout<<"Null\t";
			else
			{
				types whatEver = (t->tp_n)->basetp;
				if(whatEver == tp_char) 
					printf("%c\t",(t->i_val).char_val);
				else if(whatEver == tp_int) 
					printf("%d\t",(t->i_val).int_val);
				else if(whatEver == tp_double) 
					printf("%.3lf\t",(t->i_val).double_val);
				else 
				{
					int j = 0;
					while(j < 5)
					{
						cout<<"-";
						j++;
					}
					cout<<endl;
				}
			}				
			cout<<t->var_type;

			printf("\t\t%d\t%d\t",t->size,t->offset);
			
			if(t->var_type == "func")
				printf("ptr-to-St( %s )",t->nest_tab->name.c_str());

			if(t->tp_n != NULL)
				(t->tp_n)->print();
			
			cout<<endl;
		}
		i++;
	}

	cout<<endl;
	for(int i = 0; i < 85 ; i++)
		cout<<"+";
	cout<<endl;
}

list* makelist(int i)
{
	list *temp = (list*)malloc(sizeof(list));

	temp->index=i;
	temp->next=NULL;

	if(true)
		return temp;
	else
		return temp;
}

list* merge(list *lt1,list *lt2)
{
	list *temp = (list*)malloc(sizeof(list));
	list *pinyin1=temp;
	int flag=0;
	list *linyin=lt1;
	list *linyin2=lt2;
	while(linyin!=NULL)
	{
		flag=1;
		pinyin1->index=linyin->index;
		if(linyin->next!=NULL)
		{
			pinyin1->next=(list*)malloc(sizeof(list));
			pinyin1=pinyin1->next;
		}
		linyin=linyin->next;
	}
	while(linyin2!=NULL)
	{
		if(flag==1)
		{
			pinyin1->next=(list*)malloc(sizeof(list));
			pinyin1=pinyin1->next;
			flag=0;
		}
		pinyin1->index=linyin2->index;
		if(linyin2->next!=NULL)
		{
			pinyin1->next=(list*)malloc(sizeof(list));
			pinyin1=pinyin1->next;
		}
		linyin2=linyin2->next;
	}
	pinyin1->next=NULL;
	return temp;
}

quad::quad(opcode opc,string a1,string a2,string rs)
{
	if(true)
	{
		this->op=opc;
		this->arg1=a1;
	}
	if(zero == 0)
	{
		this->result=rs;
		this->arg2=a2;
	}
	else
		zero = 2 - 2;
}

void quad::print_arg()
{
	cout<<"\t"<<result<<"\t=\t"<<arg1<<"\top\t"<<arg2<<"\t";
}

quad_arr::quad_arr()
{
	next_instr=0;
}

void quad_arr::emit(opcode opc, string arg1, string arg2, string result)
{
	if(result.size()!=0)
	{
		quad new_elem(opc,arg1,arg2,result);
		arr.pb(new_elem);
	}
	else if(arg2.size()!=0)
	{
		quad new_elem(opc,arg1,"",arg2);
		arr.pb(new_elem);
	}
	else if(arg1.size()!=0)
	{
		quad new_elem(opc,"","",arg1);
		arr.pb(new_elem);
	}
	else
	{
		quad new_elem(opc,"","","");
		arr.pb(new_elem);
	}
	next_instr=next_instr+1;
}

void quad_arr::emit2(opcode opc,string arg1, string arg2, string result)
{
	if(result.size()==0)
	{
		quad new_elem(opc,arg1,arg2,"");
		arr.pb(new_elem);
	}
}
void quad_arr::emit(opcode opc, int val, string operand)
{
	char str[20];
	sprintf(str, "%d", val);
	int j = 0;
	while(j < 1)
	{
		if(operand.size()==0)
		{
			quad new_quad(opc,"","",str);
			arr.pb(new_quad);
		}
		else
		{
			quad new_quad(opc,str,"",operand);
			arr.pb(new_quad);
		}
		j++;
	}
	next_instr+=1;
}

void quad_arr::emit(opcode opc, double val, string operand)
{
	char str[20];
	sprintf(str, "%lf", val);
	for(int i=0;i < 1;i++)
	{
		if(operand.size()==0)
		{
			quad new_quad(opc,"","",str);
			arr.pb(new_quad);
		}
		else
		{
			quad new_quad(opc,str,"",operand);
			arr.pb(new_quad);
		}
	}
	next_instr+=1;
}

void quad_arr::emit(opcode opc, char val, string operand)
{
	char str[20];
	sprintf(str, "'%c'", val);
	if(operand.size()==0)
	{
		quad new_quad(opc,"","",str);
		arr.pb(new_quad);
	}
	else
	{
		quad new_quad(opc,str,"",operand);
		arr.pb(new_quad);
	}
	next_instr=next_instr+1;
}

void quad_arr::print()
{
	opcode op;
	string arg1;
	string arg2;
	string result;
	for(int i=0;i<next_instr;i++)
	{

		op=arr[i].op;
		arg1=arr[i].arg1;
		arg2=arr[i].arg2;
		result=arr[i].result;
		printf("%3d. :",i);
		if(Q_PLUS<=op && op<=Q_NOT_EQUAL)
	    {
			cout<<result<<"\t=\t"<<arg1<<" ";
	        
	        switch(op)
	        {
	            case Q_PLUS: cout<<"+";
							 break;
	            case Q_MINUS: cout<<"-";
							 break;
	            case Q_MULT: cout<<"*";
							 break;
	            case Q_DIVIDE: cout<<"/";
							 break;
	            case Q_MODULO: cout<<"%%";
							 break;
	            case Q_LEFT_OP: cout<<"<<";
							 break;
	            case Q_RIGHT_OP: cout<<">>";
							 break;
	            case Q_XOR: cout<<"^";
							 break;
	            case Q_AND: cout<<"&";
							 break;
	            case Q_OR: cout<<"|";
							 break;
	            case Q_LOG_AND: cout<<"&&";
							 break;
	            case Q_LOG_OR: cout<<"||";
							 break;
	            case Q_LESS: cout<<"<";
							 break;
	            case Q_LESS_OR_EQUAL: cout<<"<=";
							 break;
	            case Q_GREATER_OR_EQUAL: cout<<">=";
							 break;
	            case Q_GREATER: cout<<">";
							 break;
	            case Q_EQUAL: cout<<"==";
							 break;
	            case Q_NOT_EQUAL: cout<<"!=";
							 break;
	        }
			cout<<" "<<arg2<<endl;
	    }

	    else if(Q_UNARY_MINUS<=op && op<=Q_ASSIGN)
	    {
	        cout<<result<<"\t=\t"<<arg1<<" ";

	        switch(op)
	        {
	            
	            //Unary Assignment Instruction
	            case Q_UNARY_MINUS : cout<<"-";
									 break;
	            case Q_UNARY_PLUS : cout<<"+";
									 break;
	            case Q_COMPLEMENT : cout<<"~";
									 break;
	            case Q_NOT : cout<<"!";
									 break;
	            //Copy Assignment Instruction
	            case Q_ASSIGN :  break;
	        }
	        cout<<arg1<<endl;
	    }

	    else if(op == Q_GOTO)
			cout<<"goto "<<result<<endl;

	    else if(Q_IF_EQUAL<=op && op<=Q_IF_GREATER_OR_EQUAL)
	    {
	        cout<<"if  "<<arg1<<" ";

	        switch(op)
	        {
	            //Conditional Jump
	            case   Q_IF_LESS : cout<<"<";
									break;
	            case   Q_IF_GREATER : cout<<">";
									break;
	            case   Q_IF_LESS_OR_EQUAL : cout<<"<=";
									break;
	            case   Q_IF_GREATER_OR_EQUAL : cout<<">=";
									break;
	            case   Q_IF_EQUAL : cout<<"==";
									break;
	            case   Q_IF_NOT_EQUAL : cout<<"!=";
									break;
	            case   Q_IF_EXPRESSION : cout<<"!= 0";
									break;
	            case   Q_IF_NOT_EXPRESSION : cout<<"== 0";
									break;
	        }
	        cout<<arg2<<"\tgoto  "<<result<<endl;
	    }

	    else if(Q_CHAR2INT<=op && op<=Q_DOUBLE2INT)
	    {
			cout<<result<<"\t=\t";
	        switch(op)
	        {
	            case Q_CHAR2INT : printf(" Char2Int(");printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_CHAR2DOUBLE : printf(" Char2Double(");printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_INT2CHAR : printf(" Int2Char(");printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_DOUBLE2CHAR : printf(" Double2Char(");printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_INT2DOUBLE : printf(" Int2Double(");printf("%s",arg1.c_str());printf(")\n"); break;
	            case Q_DOUBLE2INT : printf(" Double2Int(");printf("%s",arg1.c_str());printf(")\n"); break;
	        }            
	    }
	    else if(op == Q_PARAM)
	    {
	        printf("param\t");printf("%s\n",result.c_str());
	    }
	    else if(op == Q_CALL)
	    {
	        if(!result.c_str())
					printf("call %s, %s\n", arg1.c_str(), arg2.c_str());
			else if(result.size()==0)
			{
				printf("call %s, %s\n", arg1.c_str(), arg2.c_str());
			}
			else
				printf("%s\t=\tcall %s, %s\n", result.c_str(), arg1.c_str(), arg2.c_str());
	    }
	    else if(op == Q_RETURN)
	    {
	        printf("return\t");printf("%s\n",result.c_str());
	    }
	    else if( op == Q_RINDEX)
	    {
	        printf("%s\t=\t%s[%s]\n", result.c_str(), arg1.c_str(), arg2.c_str());
	    }
	    else if(op == Q_LINDEX)
	    {
	        printf("%s[%s]\t=\t%s\n", result.c_str(), arg1.c_str(), arg2.c_str());
	    }
	    else if(op == Q_LDEREF)
	    {
	        printf("*%s\t=\t%s\n", result.c_str(), arg1.c_str());
	    }
	    else if(op == Q_RDEREF)
	    {
	    	printf("%s\t=\t* %s\n", result.c_str(), arg1.c_str());
	    }
	    else if(op == Q_ADDR)
	    {
	    	printf("%s\t=\t& %s\n", result.c_str(), arg1.c_str());
	    }
	}
}

void backpatch(list *l,int i)
{
	list *temp =l;
	list *temp2;
	char str[10];
	sprintf(str,"%d",i);
	while(temp!=NULL)
	{
		glob_quad.arr[temp->index].result = str;
		temp2=temp;
		temp=temp->next;
		free(temp2);
	}
}

void typecheck(expresn *e1,expresn *e2,bool isAssign)
{
	types type1,type2;
	//if(e2->type)
	if(e1->type==NULL)
	{
		e1->type = CopyType(e2->type);
	}
	else if(e2->type==NULL)
	{
		e2->type =CopyType(e1->type);
	}
	type1=(e1->type)->basetp;
	type2=(e2->type)->basetp;
	if(type1==type2)
	{
		return;
	}
	if(!isAssign)
	{
		if(type1>type2)
		{
			symdata *temp = curr_st->gentemp(e1->type);
			if(type1 == tp_int && type2 == tp_char)
				glob_quad.emit(Q_CHAR2INT, e2->loc->name, temp->name);
			else if(type1 == tp_double && type2 == tp_int)
				glob_quad.emit(Q_INT2DOUBLE, e2->loc->name, temp->name);
			e2->loc = temp;
			e2->type = temp->tp_n;
		}
		else
		{
			symdata *temp = curr_st->gentemp(e2->type);
			if(type2 == tp_int && type1 == tp_char)
				glob_quad.emit(Q_CHAR2INT, e1->loc->name, temp->name);
			else if(type2 == tp_double && type1 == tp_int)
				glob_quad.emit(Q_INT2DOUBLE, e1->loc->name, temp->name);	
			e1->loc = temp;
			e1->type = temp->tp_n;
		}		
	}
	else
	{
		symdata *temp = curr_st->gentemp(e1->type);
		if(type1 == tp_int && type2 == tp_double)
			glob_quad.emit(Q_DOUBLE2INT, e2->loc->name, temp->name);
		else if(type1 == tp_double && type2 == tp_int)
			glob_quad.emit(Q_INT2DOUBLE, e2->loc->name, temp->name);
		else if(type1 == tp_char && type2 == tp_int)
			glob_quad.emit(Q_INT2CHAR, e2->loc->name, temp->name);
		else if(type1 == tp_int && type2 == tp_char)
			glob_quad.emit(Q_CHAR2INT, e2->loc->name, temp->name);
		else
		{
			printf("%s %s Types compatibility not defined\n",e1->loc->name.c_str(),e2->loc->name.c_str());
			exit(-1);
		}
		e2->loc = temp;
		e2->type = temp->tp_n;
	}
}

void print_list(list *root)
{
	int flag=0;
	while(root!=NULL)
	{
		printf("%d ",root->index);
		flag=1;
		root=root->next;
	}
	if(flag==0)
	{
		printf("Empty List\n");
	}
	else
	{
		printf("\n");
	}
}
void conv2Bool(expresn *e)
{
	if((e->type)->basetp!=tp_bool)
	{
		(e->type) = new type_n(tp_bool);
		e->falselist=makelist(next_instr);
		glob_quad.emit(Q_IF_EQUAL,e->loc->name,"0","-1");
		e->truelist = makelist(next_instr);
		glob_quad.emit(Q_GOTO,-1);
	}
}

int main()
{
	symdata *temp_printi=new symdata("printi");
	temp_printi->tp_n=new type_n(tp_int);
	temp_printi->var_type="func";
	temp_printi->nest_tab=glob_st;
	glob_st->symbol_tab.pb(temp_printi);
	
	symdata *temp_readi=new symdata("readi");
	temp_readi->tp_n=new type_n(tp_int);
	temp_readi->var_type="func";
	temp_readi->nest_tab=glob_st;
	glob_st->symbol_tab.pb(temp_readi);
	
	symdata *temp_prints=new symdata("prints");
	temp_prints->tp_n=new type_n(tp_int);
	temp_prints->var_type="func";
	temp_prints->nest_tab=glob_st;
	glob_st->symbol_tab.pb(temp_prints);
	yyparse();
	glob_st->name="Global";
	printf("==============================================================================");
	printf("\nGenerated Quads for the program\n");
	glob_quad.print();
	printf("==============================================================================\n");
	printf("Symbol table Maintained For the Given Program\n");
	glob_st->print();
	set<string> setty;
	setty.insert("Global");
	/*for(int i=0; i<glob_st->symbol_tab.size();i++)
	{
		if(((glob_st->symbol_tab[i])->nest_tab)!=NULL)
		{
			if(setty.find(((glob_st->symbol_tab[i])->nest_tab)->name)==setty.end())
		{
			((glob_st->symbol_tab[i])->nest_tab)->print();
			setty.insert(((glob_st->symbol_tab[i])->nest_tab)->name);
			//printf("%s\n",((glob_st->symbol_tab[i])->nest_tab)->name.c_str() );
		}
	}
	}*/
	printf("=============================================================================\n");
	FILE *fp;
	fp = fopen("output.s","w");
	fprintf(fp,"\t.file\t\"output.s\"\n");
	//Print the data of the strings here
	for (int i = 0; i < strings_label.size(); ++i)
	{
		fprintf(fp,"\n.STR%d:\t.string %s",i,strings_label[i].c_str());	
	}
	set<string>setty_1;
	glob_st->mark_labels();
	glob_st->global_variables(fp);
	setty_1.insert("Global");
	int count_l=0;
	for (int i = 0; i < glob_st->symbol_tab.size(); ++i)
	{
		if(((glob_st->symbol_tab[i])->nest_tab)!=NULL)
		{
			if(setty_1.find(((glob_st->symbol_tab[i])->nest_tab)->name)==setty_1.end())
			{
				glob_st->symbol_tab[i]->nest_tab->assign_offset();
				glob_st->symbol_tab[i]->nest_tab->print();
				glob_st->symbol_tab[i]->nest_tab->function_prologue(fp,count_l);
				glob_st->symbol_tab[i]->nest_tab->function_restore(fp);
				glob_st->symbol_tab[i]->nest_tab->gen_internal_code(fp,count_l);
				setty_1.insert(((glob_st->symbol_tab[i])->nest_tab)->name);
				glob_st->symbol_tab[i]->nest_tab->function_epilogue(fp,count_l,count_l);
				count_l++;
			}
		}
	}
	fprintf(fp,"\n");
	return 0;
}
