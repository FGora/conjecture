def secreps(lat1,lat2):
""" Computes the intersection of two representatives of lattices."""
   global n
   global k
   return [(stats.IntList([lat1[j],lat2[j]]).max()) for j in range(binomial(n,k))]    

def sec(v,w):
""" Computes all the intersections of two lattices. """
   global n
   global k
   con = [v,w]
   lb = min(w[i]-v[i] for i in range(binomial(n,k)))
   ub = max(w[i]-v[i] for i in range(binomial(n,k)))
   for j in range(ub-lb):
      if not any(same(secreps(w,[(v[i]+j+lb)for i in range(binomial(n,k))]),t ) for t in con):
         con.append(secreps(w,[(v[i]+j+lb)for i in range(binomial(n,k))]))
   return [lat for lat in con if lat not in [v,w]]

def same(v,w):
""" Checks whether two lattices have the same homothety class. """
   global n
   global k
   minimum =  min(w[j]-v[j] for j in range(binomial(n,k)))
   for i in range(binomial(n,k))	:
     if w[i]-v[i]-minimum >0:
        return False
   return True

def testconvex(lis,G):
""" Checks whether a list of lattices is convex."""
   for tpl in Combinations(lis,2).list():
      for intersection in sec(G.get_vertex(tpl[0]),G.get_vertex(tpl[1])):
         if not any(same(intersection,t) for t in [G.get_vertex(v) for v in lis]):
            return False
   return True         

def convex(G):
""" Extends the graph of lattices, to the convex closure."""
   while testconvex(G.vertices(),G)==False:
      for tpl in Combinations(G.vertices(),2).list():
         i = 0
         for intsec in sec(G.get_vertex(tpl[0]),G.get_vertex(tpl[1])):
            if not any(same(intsec,t) for t in [G.get_vertex(v) for v in G.vertices()]):
               G.add_vertex('(%s cap %s)_%d' %(tpl[0],tpl[1],i))
               G.set_vertex('(%s cap %s)_%d' %(tpl[0],tpl[1],i), intsec)
               i=i+1              
 
def gr(n,k):
""" Defines the Graph of lattices for the convex closure of the wedgeproduct of the standard lattice chain."""
   global G
   G=graphs.EmptyGraph()
   for i in range(n):
      G.add_vertex('L%d' %i)
      lat=[]
      for j in Combinations(range(n),k).list():  
         ent = 0
         for b in j:
            if b<i:
               ent = ent + 1
         lat.append(ent)
      G.set_vertex('L%d' %i, lat)
   vert1=G.get_vertices()   
   convex(G)
   vert2=[v for v in G.get_vertices() if not v in vert1]
#   print('case (n,k)= (%d , %d)' %(n,k) )
   return [vert1,vert2]       

def conj(a,b):
""" Falsifies the conjecture for the given parameters. """
   global n
   global k
   n=a
   k=b
   vert=gr(n,k)
   for lambda1 in vert[1]:
      wl=[]
      for lambda2 in vert[0]:
         wl.append(kern(G.get_vertex(lambda1),G.get_vertex(lambda2)))
      if condition(wl,binomial(n,k),n)==False:
         print(False)
         return wl       
   return True      	

def kern(lambda1,lambda2):
"""Computes the kernel of the map between two lattices."""
   w=Set([])
   maximaldiff =  max(lambda2[j]-lambda1[j] for j in range(binomial(n,k)))
   for j in range(binomial(n,k)):
      if not lambda2[j]-lambda1[j]==maximaldiff:
         w=Set({j}).union(Set(w))
   return w


# def check(li,d,n):
#   bol = True
#   insec = Set(range(d))
#   for i in range(n):
#     insec=li[i].intersection(insec)	
#   if not insec.is_empty():
#     bol= False
#   return bol 	

# def condition(sset,d,n):
#   B=[]
#   for i in range(n):
#      B.append(range(d-sset[i].cardinality()))  
#   if True in [bol[1] for bol in iselement([(m,sset,d,n) for m in cartesian_product(B)])]:
#     return True
#   return False         

# @parallel
# def iselement(li_1,li_2,d,n):
#   if not sum(li_1)==d-1:
#      return false   
#   for I in Subsets(range(n)):
#     if not I.is_empty():
#       Wi=Set(range(d))
#       for i in I:
#          Wi=Wi.intersection(li_2[i])
#       if d-sum((li_1[i]) for i in I) <= Wi.cardinality():
#          return False  
#   return True  

def condition(sset,d,n):
"""Defining the function checking the condition for the set of subsets."""
  bol = False
  B=[]
  for i in range(n):
     B.append(range(d-sset[i].cardinality()))
  for m in cartesian_product(B): 
     if iselement(m,sset,d,n):
        return True
 # print(False)      
  return False         

def iselement(li_1,li_2,d,n):
""" Checks the containement of an element."""
  if not sum(li_1)==d-1:
     return False   
  for I in Subsets(range(n)):
    if not I.is_empty():
      Wi=Set(range(d))
      for i in I:
         Wi=Wi.intersection(li_2[i])
      if d-sum((li_1[i]) for i in I) <= Wi.cardinality():
         return False
  return True  

def out(start,end):
""" Defining the function for creating an output. """
   print('n | k | Conjecture')
   for n in range(end-start):
      for k in range(((n+start)/2).floor()-2):
         print( str(n+start) + " | " + str(k+3)+ " | " + str(conj(n+start,k+3)))
def ask():
   """ Ask for the boundaries of the computations. """
   print("What is the smallest case to check?")
   start= int(raw_input())
   print("What is the biggest case to check?")
   end = int(raw_input())+1
   out(start,end)


# The result: 
ask()