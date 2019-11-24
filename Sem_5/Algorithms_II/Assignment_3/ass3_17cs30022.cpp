#include<bits/stdc++.h>
using namespace std;

#define fi first
#define se second
#define pa pair<int,int> 

// Function to calculate the distance between two points 
float dist(pa p1, pa p2)
{
    return sqrt((p1.fi-p2.fi)*(p1.fi-p2.fi)+(p1.se-p2.se)*(p1.se-p2.se));
}

// Comparator for sorting y coordinate
bool comp(pa lhs, pa rhs)
{
    return lhs.se < rhs.se;
}

// Comparator for sorting x coordinate
bool comp1(pa lhs, pa rhs)
{
    if( lhs.fi == rhs.fi)
        return lhs.se < rhs.se;
    return lhs.fi < rhs.fi;
}

// Function to generate n distinct random points
void generate_points(int n, vector< pa >& points)
{
    set< pa > temp;
    while(temp.size()!=n)
        temp.insert({rand()%880+10,rand()%580+10});
    
    for(pa ce : temp)
        points.push_back(ce);
}

// Function to combine the left and right of the divide and conquer
pair< float , pair< pa , pa > > combine(vector< pa > Y_sort, float delta, int x_part)
{
    // Omittiing points that are not within delta distance from the mid
    vector< pa > Y_omitted;
    for(pa temp : Y_sort)
        if(abs(temp.fi - x_part) <= delta)
            Y_omitted.push_back(temp);

    // Calculating the minimum distance for the left and right pairs
    float temp_ans = 1e9;
    pair< pa, pa > ans;
    for(int i=0;i<Y_omitted.size();i++)
    {
        for(int j=i+1;j<Y_omitted.size();j++)
        {
            if(Y_omitted[j].se - Y_omitted[i].se > delta)
                break;
             if(dist(Y_omitted[i],Y_omitted[j]) < temp_ans)
                temp_ans = dist(Y_omitted[i],Y_omitted[j]), ans = {Y_omitted[i],Y_omitted[j]} ;
        }
    }

    return {temp_ans,ans};
}

pair< pa, pa > recurse(int left, int right, vector< pa > X_sort, vector< pa > Y_sort )
{
    // If there are only three points, brute force
    if(right - left <= 2)
    {
        float temp = 1e9;
        pair< pa , pa >  ans;

        for(int i=left;i<right;i++)
            for(int j=i+1;j<=right;j++)
                if(temp > dist(X_sort[i],X_sort[j]))
                    temp = dist(X_sort[i],X_sort[j]), ans = {X_sort[i],X_sort[j]};
        
        return ans;
    }

    vector< pa > Y_left, Y_right;
    int mid = left + right >> 1;
    int x_part = X_sort[mid].fi, y_part = X_sort[mid].se;

    // Sort y from the pre sorted array
    for(pa temp: Y_sort)
        if(temp.fi < x_part)
            Y_left.push_back(temp);
        else if(temp.fi > x_part)
            Y_right.push_back(temp);
        else if( temp.se <= y_part)
            Y_left.push_back(temp);
        else
            Y_right.push_back(temp);
    
    // Calculate left and right and then combine
    pair< pa , pa >  ans_left, ans_right;
    ans_left = recurse(left, mid, X_sort, Y_left), ans_right = recurse(mid+1, right, X_sort, Y_right);
    float delta = min(dist(ans_left.fi,ans_left.se),dist(ans_left.fi,ans_left.se));
    pair< float, pair< pa, pa > > ans_comb = combine(Y_sort,delta,x_part);
    
    // Return the best answer
    if(ans_comb.fi < delta)
        return ans_comb.se;
    else if(dist(ans_left.fi,ans_left.se) < dist(ans_right.fi,ans_right.se))
        return ans_left;
    else
        return ans_right;

}

// Function to find the closest pair of points
pair< pa , pa > find_closest(vector< pa > points)
{
    int n = points.size();
    vector< pa > points_X = points, points_Y = points;
    sort(points_X.begin(),points_X.end(),comp1);
    sort(points_Y.begin(),points_Y.end(),comp);
    return recurse(0,n-1,points_X,points_Y);
}

int main()
{

    srand(unsigned(time(0)));

    int n;
    cout<<"Enter the value of n: ";
    cin>>n;

    // Generate the n points
    vector< pa > points;
    generate_points(n, points);

    // find the closest pair of points and its distance
    pair< pa , pa > ans = find_closest(points);
    int distance = dist(ans.fi,ans.se);

    // Generate the svg file
    string svgfile = "";
    svgfile += "<svg xmlns=\"http://www.w3.org/2000/svg\">";
    svgfile += "\n<rect width=\"900\" height=\"600\" style=\"fill:rgb(0,0,0); stroke-width:0; stroke:rgb(255,255,255)\" />"; 
    
    // draw the circles
    for(pa temp : points)
        svgfile += "<circle cx=\"" + to_string(temp.fi) + "\" cy=\"" + to_string(temp.se) + "\" r=\"" + to_string(distance/2.0) + "\" stroke=\"#ffffff\" stroke-width=\"1\" fill=\"#00ff00\" fill-opacity=\"0.3\" />";
    
    // Plot the points
    for(pa temp : points)
        svgfile += "\n<circle cx=\""+to_string(temp.fi)+"\" cy=\""+to_string(temp.se)+"\" r=\"2\" stroke=\"white\" stroke-width=\"0\" fill=\"#ff0000\" />";
    
    svgfile += "\n</svg>";

    ofstream svg("points.svg");

    cout<<"The output is presented in \"points.svg\" file \n";
    svg<<svgfile<<endl;
    return 0;
}