// =====================================================================
// SOCIAL NETWORK ANALYSIS – NEO4J SCRIPT
// Run each block separately in Neo4j Browser / Aura Query (Ctrl+Enter).
// =====================================================================

// ---------- 0. RESET (run first, and any time you re-run the setup) ----------
MATCH (n) DETACH DELETE n;

// ---------- 1. Users ----------
CREATE
(:User {name:'Rahul', age:29, city:'Pune', profession:'Data Scientist', activityLevel:92, influenceScore:87}),
(:User {name:'Priya', age:27, city:'Mumbai', profession:'AI Engineer', activityLevel:88, influenceScore:82}),
(:User {name:'Amit', age:31, city:'Pune', profession:'Entrepreneur', activityLevel:76, influenceScore:79}),
(:User {name:'Neha', age:25, city:'Delhi', profession:'Researcher', activityLevel:95, influenceScore:91}),
(:User {name:'Karan', age:30, city:'Pune', profession:'Software Engineer', activityLevel:69, influenceScore:73}),
(:User {name:'Sneha', age:28, city:'Mumbai', profession:'Product Manager', activityLevel:84, influenceScore:86}),
(:User {name:'Arjun', age:26, city:'Bengaluru', profession:'ML Engineer', activityLevel:91, influenceScore:89}),
(:User {name:'Meera', age:32, city:'Delhi', profession:'Consultant', activityLevel:72, influenceScore:77});

// ---------- 2. Friendships ----------
MATCH
(r:User {name:'Rahul'}), (p:User {name:'Priya'}), (a:User {name:'Amit'}), (n:User {name:'Neha'}),
(k:User {name:'Karan'}), (s:User {name:'Sneha'}), (ar:User {name:'Arjun'}), (m:User {name:'Meera'})
CREATE
(r)-[:FRIEND {since:2021, strength:0.91}]->(p),
(r)-[:FRIEND {since:2022, strength:0.75}]->(a),
(r)-[:FRIEND {since:2023, strength:0.64}]->(k),
(p)-[:FRIEND {since:2022, strength:0.83}]->(n),
(p)-[:FRIEND {since:2021, strength:0.89}]->(s),
(n)-[:FRIEND {since:2023, strength:0.71}]->(ar),
(n)-[:FRIEND {since:2022, strength:0.68}]->(m),
(a)-[:FRIEND {since:2024, strength:0.62}]->(k),
(s)-[:FRIEND {since:2023, strength:0.77}]->(ar),
(ar)-[:FRIEND {since:2024, strength:0.66}]->(m);

// ---------- 3. Groups ----------
CREATE
(:Group {name:'Artificial Intelligence', category:'Technology', members:420}),
(:Group {name:'Data Science', category:'Technology', members:350}),
(:Group {name:'Startup Founders', category:'Business', members:210});

// ---------- 4. Group membership ----------
MATCH
(r:User {name:'Rahul'}), (p:User {name:'Priya'}), (n:User {name:'Neha'}), (a:User {name:'Amit'}),
(s:User {name:'Sneha'}), (ar:User {name:'Arjun'}),
(g1:Group {name:'Artificial Intelligence'}), (g2:Group {name:'Data Science'}),
(g3:Group {name:'Startup Founders'})
CREATE
(r)-[:MEMBER_OF {role:'Member', since:2022}]->(g1),
(r)-[:MEMBER_OF {role:'Moderator', since:2021}]->(g2),
(p)-[:MEMBER_OF {role:'Member', since:2023}]->(g1),
(p)-[:MEMBER_OF {role:'Member', since:2022}]->(g2),
(n)-[:MEMBER_OF {role:'Researcher', since:2021}]->(g1),
(n)-[:MEMBER_OF {role:'Member', since:2023}]->(g2),
(a)-[:MEMBER_OF {role:'Founder', since:2022}]->(g3),
(s)-[:MEMBER_OF {role:'Member', since:2023}]->(g1),
(ar)-[:MEMBER_OF {role:'Member', since:2022}]->(g1),
(ar)-[:MEMBER_OF {role:'Member', since:2023}]->(g2);

// ---------- 5. Comments ----------
CREATE
(:Comment {id:'C001', text:'Graph databases are very useful for connected data.', sentiment:'Positive', toxicity:0.02, likes:34, timestamp:'2026-08-20'}),
(:Comment {id:'C002', text:'I think Graph RAG can improve knowledge retrieval.', sentiment:'Positive', toxicity:0.01, likes:41, timestamp:'2026-08-21'}),
(:Comment {id:'C003', text:'The performance depends heavily on the graph structure.', sentiment:'Neutral', toxicity:0.03, likes:18, timestamp:'2026-08-21'}),
(:Comment {id:'C004', text:'Interesting perspective on community detection.', sentiment:'Positive', toxicity:0.00, likes:29, timestamp:'2026-08-22'}),
(:Comment {id:'C005', text:'I disagree with this approach.', sentiment:'Negative', toxicity:0.12, likes:9, timestamp:'2026-08-22'});

// ---------- 6. Who commented ----------
MATCH
(r:User {name:'Rahul'}), (p:User {name:'Priya'}), (n:User {name:'Neha'}), (a:User {name:'Amit'}), (s:User {name:'Sneha'}),
(c1:Comment {id:'C001'}), (c2:Comment {id:'C002'}), (c3:Comment {id:'C003'}), (c4:Comment {id:'C004'}), (c5:Comment {id:'C005'})
CREATE
(r)-[:COMMENTED {time:'10:30'}]->(c1),
(p)-[:COMMENTED {time:'11:10'}]->(c2),
(n)-[:COMMENTED {time:'12:15'}]->(c3),
(a)-[:COMMENTED {time:'13:20'}]->(c4),
(s)-[:COMMENTED {time:'14:05'}]->(c5);

// ---------- 7. Replies ----------
MATCH
(p:User {name:'Priya'}), (n:User {name:'Neha'}),
(c1:Comment {id:'C001'}), (c3:Comment {id:'C003'})
CREATE
(p)-[:REPLIED_TO]->(c1),
(n)-[:REPLIED_TO]->(c1),
(p)-[:REPLIED_TO]->(c3);

// ---------- 8. Topics ----------
CREATE
(:Topic {name:'Graph Database'}),
(:Topic {name:'Graph RAG'}),
(:Topic {name:'Community Detection'}),
(:Topic {name:'Social Network Analysis'});

// ---------- 9. Comment -> Topic ----------
MATCH
(c1:Comment {id:'C001'}), (c2:Comment {id:'C002'}), (c3:Comment {id:'C003'}), (c4:Comment {id:'C004'}),
(t1:Topic {name:'Graph Database'}), (t2:Topic {name:'Graph RAG'}), (t3:Topic {name:'Community Detection'})
CREATE
(c1)-[:ABOUT]->(t1),
(c2)-[:ABOUT]->(t2),
(c3)-[:ABOUT]->(t1),
(c4)-[:ABOUT]->(t3);

// ---------- Sanity check: expect 20 nodes, 32 relationships ----------
MATCH (n) WITH count(n) AS nodes
MATCH ()-[r]->() RETURN nodes, count(r) AS relationships;


// =====================================================================
// EXERCISES
// =====================================================================

// Ex 1 – Complete user network (all user-to-user relationships)
MATCH (u:User)-[r]-(v:User)
RETURN u, r, v;

// Ex 2 – Friendships only
MATCH (u:User)-[r:FRIEND]->(v:User)
RETURN u, r, v;

// Ex 3 – Rahul's one-hop ego network
MATCH (rahul:User {name:'Rahul'})-[f:FRIEND]-(friend:User)
RETURN rahul, f, friend;

// Ex 4 – Friends-of-friends: exactly 2 hops, excluding direct friends
MATCH path = (rahul:User {name:'Rahul'})-[:FRIEND*2]-(fof:User)
WHERE fof <> rahul
  AND NOT (rahul)-[:FRIEND]-(fof)
RETURN path;

// Ex 5 – One to three hops
MATCH path = (rahul:User {name:'Rahul'})-[:FRIEND*1..3]-(v:User)
RETURN path;

// Ex 6 – All friendship paths between Rahul and Karan
MATCH path = (rahul:User {name:'Rahul'})-[:FRIEND*1..6]-(karan:User {name:'Karan'})
RETURN path;

// Ex 7a – Shortest connection between two chosen users (change names as needed)
MATCH (a:User {name:'Rahul'}), (b:User {name:'Meera'})
MATCH path = shortestPath((a)-[:FRIEND*]-(b))
RETURN path;

// Ex 7b – Shortest connection for every pair of users (table)
MATCH (a:User), (b:User)
WHERE a.name < b.name
MATCH path = shortestPath((a)-[:FRIEND*]-(b))
RETURN a.name AS from, b.name AS to, length(path) AS hops,
       [n IN nodes(path) | n.name] AS route
ORDER BY hops DESC;

// Ex 8a – Longest simple friendship path (no user repeated)
MATCH path = (a:User)-[:FRIEND*]-(b:User)
WHERE a.name < b.name
  AND ALL(n IN nodes(path) WHERE single(x IN nodes(path) WHERE x = n))
RETURN path, length(path) AS hops
ORDER BY hops DESC
LIMIT 1;

// Ex 8b – Network diameter: the longest of all shortest paths
MATCH (a:User), (b:User)
WHERE a.name < b.name
MATCH path = shortestPath((a)-[:FRIEND*]-(b))
RETURN path, length(path) AS hops
ORDER BY hops DESC
LIMIT 1;

// Ex 9 – Users and groups
MATCH (u:User)-[m:MEMBER_OF]->(g:Group)
RETURN u, m, g;

// Ex 10 – Users and their comments
MATCH (u:User)-[c:COMMENTED]->(cm:Comment)
RETURN u, c, cm;

// Ex 11 – Comment conversation network (author + repliers)
MATCH (author:User)-[c:COMMENTED]->(cm:Comment)<-[rep:REPLIED_TO]-(replier:User)
RETURN author, c, cm, rep, replier;

// Ex 12 – Users -> comments -> topics
MATCH (u:User)-[c:COMMENTED]->(cm:Comment)-[a:ABOUT]->(t:Topic)
RETURN u, c, cm, a, t;

// Ex 13 – Users discussing the same topic
MATCH p1 = (u1:User)-[:COMMENTED]->(:Comment)-[:ABOUT]->(t:Topic),
      p2 = (u2:User)-[:COMMENTED]->(:Comment)-[:ABOUT]->(t)
WHERE u1.name < u2.name
RETURN p1, p2;

// Ex 13 (table version)
MATCH (u1:User)-[:COMMENTED]->(:Comment)-[:ABOUT]->(t:Topic)<-[:ABOUT]-(:Comment)<-[:COMMENTED]-(u2:User)
WHERE u1.name < u2.name
RETURN t.name AS topic, u1.name AS user1, u2.name AS user2;

// Ex 14 – High-toxicity interaction (threshold 0.10)
MATCH (author:User)-[cm:COMMENTED]->(c:Comment)
WHERE c.toxicity >= 0.10
OPTIONAL MATCH (replier:User)-[rep:REPLIED_TO]->(c)
OPTIONAL MATCH (author)-[f:FRIEND]-(friend:User)
RETURN author, cm, c, replier, rep, f, friend;

// Ex 15a – Friend recommendation graph for Rahul (mutual-friend paths)
MATCH path = (rahul:User {name:'Rahul'})-[:FRIEND]-(mutual:User)-[:FRIEND]-(rec:User)
WHERE rec <> rahul
  AND NOT (rahul)-[:FRIEND]-(rec)
RETURN path;

// Ex 15b – Ranked recommendations (mutual friends + shared groups)
MATCH (rahul:User {name:'Rahul'})-[:FRIEND]-(mutual:User)-[:FRIEND]-(rec:User)
WHERE rec <> rahul AND NOT (rahul)-[:FRIEND]-(rec)
WITH rahul, rec, collect(DISTINCT mutual.name) AS mutualFriends
OPTIONAL MATCH (rahul)-[:MEMBER_OF]->(g:Group)<-[:MEMBER_OF]-(rec)
RETURN rec.name AS recommended, mutualFriends,
       collect(g.name) AS sharedGroups,
       size(mutualFriends) + count(g) AS score
ORDER BY score DESC;

// Ex 16 – Complete social interaction graph (includes isolated nodes)
MATCH (n)
OPTIONAL MATCH (n)-[r]->(m)
RETURN n, r, m;
