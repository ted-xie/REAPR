def clustering_coefficient(connections):
    num_src_nodes = len(connections)
    if num_src_nodes == 1: return 0.0
    links = 0.0
    for node in connections:
        vertices = connections[node]
        for vertex in vertices:
               if vertex in connections:
                    links += 0.5 
    return 2.0*links/(num_src_nodes*num_src_nodes-1)
