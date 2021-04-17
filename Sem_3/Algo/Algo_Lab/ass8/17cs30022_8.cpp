#include<bits/stdc++.h>
using namespace std;

typedef struct score
{
    int mscore;
    int escore;
}score, *scorelist;

typedef struct _student
{
	score marks;
	int sect;
}stud, *studlist;

int dist(score s1, score s2)
{
    return (abs(s1.escore-s2.escore)+abs(s1.mscore-s2.mscore));
}

// ===========PART 2============ //

void merge1(studlist T,int a, int b, int c)
{
	stud l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=T[a+i];
	for(int i=0;i<c-b;i++) r[i]=T[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].marks.mscore < r[y].marks.mscore) T[k++]=l[x++];
		else if(l[x].marks.mscore==r[y].marks.mscore && l[x].marks.escore<r[y].marks.escore) T[k++]=l[x++];
		else T[k++]=r[y++];
	}
	while(x<b-a+1) T[k++]=l[x++];
	while(y<c-b) T[k++]=r[y++];	
}

void sort1(studlist T,int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort1(T,a,mid);
	sort1(T,mid+1,b);
	merge1(T,a,mid,b);
}

int algo_merge1(studlist T, int beg, int mid, int end, score *score1, score *score2,int del)
{
	del=min(del,100);
	int div=T[mid].marks.mscore;
	int posl=beg;
	while(posl<=mid)
	{
		if(abs(T[posl].marks.mscore - T[mid].marks.mscore) <=  del) break;
		posl++; 
	}
	
	int posr=end;
	while(posr>mid)
	{
		if(abs(T[posr].marks.mscore - T[mid].marks.mscore) <=  del) break;
		posr--; 
	}
	if(posr==mid) return 1e9;
	
	int dis_cur=1e9;

	for(int i=posl;i<=mid;i++)
	{
		for(int j=mid+1;j<=posr;j++)
		{
			if(dis_cur>dist(T[i].marks,T[j].marks) && T[i].sect!=T[j].sect)
			{
				dis_cur=dist(T[i].marks,T[j].marks);
				*score1=T[i].marks;							
				*score2=T[j].marks;
			}
		}
	}
	
	return dis_cur;
}

int algo1(studlist T, int beg, int end, score *score1, score *score2)
{
    if(beg>=end) return 1e9;
    int mid=(beg+end)/2;
    
    score *fir1=(scorelist)malloc(sizeof(score)),*fir2=(scorelist)malloc(sizeof(score));
    int dis1;
    dis1=algo1(T,beg,mid,fir1,fir2);
    
    score *sec1=(scorelist)malloc(sizeof(score)),*sec2=(scorelist)malloc(sizeof(score));
    int dis2;
    dis2=algo1(T,mid+1,end,sec1,sec2);
    
    score *fin1=(scorelist)malloc(sizeof(score)),*fin2=(scorelist)malloc(sizeof(score));
    int dis3;
    dis3=algo_merge1(T,beg,mid,end,fin1,fin2,min(dis1,dis2));
	
	int pos;
	if(dis1 < dis2) pos=1;
	else pos=2;
	if(dis3 < min(dis1,dis2)) pos=3;
	
	if(pos==1)
	{
		*score1=*fir1;
		*score2=*fir2;
		return dis1;
	}
	if(pos==2)
	{
		*score1=*sec1;
		*score2=*sec2;
		return dis2;
	}
	if(pos==3)
	{
		*score1=*fin1;
		*score2=*fin2;
		return dis3;
	}	
}


int ClusterDist(scorelist section1, int n, scorelist section2, int m, score *score1, score *score2)
{
	stud T[n+m];
	for(int i=0;i<n;i++) 
	{
		T[i].marks=section1[i];
		T[i].sect=1;
	}
	for(int i=0;i<m;i++) 
	{
		T[i+n].marks=section2[i];
		T[i+n].sect=2;
	}
	sort1(T,0,n+m-1);
    return algo1(T,0,n+m-1,score1,score2);
}

// ====PART 1 ==== //
void merge(scorelist T,int a, int b, int c)
{
	score l[b-a+1],r[c-b];
	for(int i=0;i<b-a+1;i++) l[i]=T[a+i];
	for(int i=0;i<c-b;i++) r[i]=T[b+1+i];
	int k=a,x=0,y=0;
	while(x<b-a+1 && y<c-b)
	{
		if(l[x].mscore < r[y].mscore) T[k++]=l[x++];
		else if(l[x].mscore==r[y].mscore && l[x].escore<r[y].escore) T[k++]=l[x++];
		else T[k++]=r[y++];
	}
	while(x<b-a+1) T[k++]=l[x++];
	while(y<c-b) T[k++]=r[y++];	
}

void sort(scorelist T,int a,int b)
{
	if(a>=b) return;
	int mid=(a+b)/2;
	sort(T,a,mid);
	sort(T,mid+1,b);
	merge(T,a,mid,b);
}



int algo_merge(scorelist T, int beg, int mid, int end, score *score1, score *score2,int del)
{
	del=min(del,100);
	int div=T[mid].mscore;
	int posl=beg;
	while(posl<=mid)
	{
		if(abs(T[posl].mscore - T[mid].mscore) <=  del) break;
		posl++; 
	}
	
	int posr=end;
	while(posr>mid)
	{
		if(abs(T[posr].mscore - T[mid].mscore) <=  del) break;
		posr--; 
	}
	if(posr==mid) return 1e9;
	
	int dis_cur=1000;

	// By pigeonhole principle, the following double loop runs in O(mid-beg)
	for(int i=posl;i<=mid;i++)
	{
		for(int j=mid+1;j<=posr;j++)
		{
			if(dis_cur>dist(T[i],T[j]))
			{
				dis_cur=dist(T[i],T[j]);
				*score1=T[i];							
				*score2=T[j];
			}
		}
	}
	
	return dis_cur;
}

int algo(scorelist T, int beg, int end, score *score1, score *score2)
{
    if(beg>=end) return 1e9;
    int mid=(beg+end)/2;
    
    score *fir1=(scorelist)malloc(sizeof(score)),*fir2=(scorelist)malloc(sizeof(score));
    int dis1;
    dis1=algo(T,beg,mid,fir1,fir2);
    
    score *sec1=(scorelist)malloc(sizeof(score)),*sec2=(scorelist)malloc(sizeof(score));
    int dis2;
    dis2=algo(T,mid+1,end,sec1,sec2);
    
    score *fin1=(scorelist)malloc(sizeof(score)),*fin2=(scorelist)malloc(sizeof(score));
    int dis3;
    dis3=algo_merge(T,beg,mid,end,fin1,fin2,min(dis1,dis2));
	
	int pos;
	if(dis1 < dis2) pos=1;
	else pos=2;
	if(dis3 < min(dis1,dis2)) pos=3;
	
	if(pos==1)
	{
		*score1=*fir1;
		*score2=*fir2;
		return dis1;
	}
	if(pos==2)
	{
		*score1=*sec1;
		*score2=*sec2;
		return dis2;
	}
	if(pos==3)
	{
		*score1=*fin1;
		*score2=*fin2;
		return dis3;
	}	
}

int NearestProfiles(scorelist T, int n, score *score1, score *score2)
{
    sort(T,0,n-1);
	for(int i=0;i<n-1;i++)
	{
		if(!dist(T[i],T[i+1]))
		{
			*score1=T[i];
			*score2=T[i+1];
			return 0;
		}
	}
    return algo(T,0,n-1,score1,score2);
}

int main(int argc, char **argv)
{
    int n;
    score profile1, profile2;
    cout<<"Enter the number of students:- ";
    cin>>n;
    score T[n];
    for(int i=0;i<n;i++)
    {
        printf("Enter the student %d maths and english scores:- ",i+1);
        cin>>T[i].mscore>>T[i].escore;
    }
    int dist=NearestProfiles(T,n,&profile1,&profile2);
	printf("\nClosest pair: (%d,%d) and (%d,%d)\nClosest distance=%d\n",profile1.mscore,profile1.escore,profile2.mscore,profile2.escore,dist);	

	int m;
	cout<<"Enter the number of students in the second cluster:- ";
    cin>>m;
    score W[m];
	for(int i=0;i<m;i++)
    {
        printf("Enter the student %d maths and english scores:- ",i+1);
        cin>>W[i].mscore>>W[i].escore;
    }
    int dist1=ClusterDist(T,n,W,m,&profile1,&profile2);
	printf("\nClosest pair: (%d,%d) and (%d,%d)\nClosest distance=%d\n",profile1.mscore,profile1.escore,profile2.mscore,profile2.escore,dist1);

	return 0;
}
