 <div class="col-md-3 col-md-offset-1 col-sm-5 col-xs-12">
                           <div class="total-widget">
                             
                               <div class="single-widget catagory-widget">
                                  <h3 class="aside-title uppercase">Event Categories</h3>
                                   <ul>
                                    <?php
$sql = "SELECT id,CategoryName  from tblcategory";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
?>
<li><a href="category-wise-events.php?catid=<?php echo htmlentities($row->id);?>"><?php echo htmlentities($row->CategoryName);?></a></li>
<?php }} ?>
                                   </ul>
                               </div>
                            
                       </div>
                   </div>