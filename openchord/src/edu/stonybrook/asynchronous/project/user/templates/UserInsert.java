package edu.stonybrook.asynchronous.project.user.templates;

import java.io.Serializable;

import edu.stonybrook.asynchronous.project.data.StringKey;

public interface UserInsert {

	public void insertData(StringKey key, Serializable data);
}
