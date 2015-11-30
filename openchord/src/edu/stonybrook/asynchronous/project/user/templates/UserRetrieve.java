package edu.stonybrook.asynchronous.project.user.templates;

import java.io.Serializable;
import java.util.Set;

import edu.stonybrook.asynchronous.project.data.StringKey;

public interface UserRetrieve {
	public Set<Serializable> retrieve(StringKey key);
}
